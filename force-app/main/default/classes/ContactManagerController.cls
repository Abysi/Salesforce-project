public class ContactManagerController {
    
    private String token{get;set;}
    private String userId{get;set;}
    
    public String message{get;set;}
    
    public pageReference init(){
        
        userId = ApexPages.currentPage().getParameters().get('id');
        token = ApexPages.currentPage().getParameters().get('token');
        Boolean isValidToken = SalesforceWebToken.IsValidToken(token, userId);
        if(isValidToken){
            return null;
        }else{
            return PageRoutes.startPage();
        }
    }
    
    public pageReference  Save(){
        
        ProjectUser__c userManager = [SELECT Id, Login__c 
                                      FROM ProjectUser__c 
                                      WHERE RecordType.Name = 'Manager' 
                                      LIMIT 1];
        Utils.SendMail(userManager.Login__c, message);
        return  PageRoutes.autUserRoutes('/apex/detailUserPage', userId, token);
    }
}