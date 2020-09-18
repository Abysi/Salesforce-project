public class PaymentHistoryController {
    
    private String userId;
    private String token{get;set;}
    
    public List< Payment__c> pays;
    
    public pageReference init(){
        
        userId = ApexPages.currentPage().getParameters().get('id');
        token = ApexPages.currentPage().getParameters().get('token');
        Boolean isValidToken = SalesforceWebToken.IsValidToken(token, userId);
        if(isValidToken){
            pays = [SELECT PaymentSumm__c, Date__c, Name 
                    FROM Payment__c 
                    WHERE ProjectUser__c =: userId 
                    ORDER BY Date__c DESC];
            return null;
        }else{
          return PageRoutes.startPage();
        }
    }
    
    public  List<Payment__c> getPayments(){
        
        return pays;
    }
    
    public pageReference home(){
         return  PageRoutes.autUserRoutes('/apex/detailUserPage', userId, token);
    }
}