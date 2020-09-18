public class UsersPaymentHistoryController {
    
    private String token{get;set;}
    private String userId{get;set;}
    
    public ProjectUser__c managerRegion{get;set;}
    public String currentUserId{get;set;}
    public List< Payment__c> pays;
    
    
    public  List<ProjectUser__c> getUsers(){
        
        List<ProjectUser__c> users = [SELECT Id, Name, Region__c 
                                      FROM ProjectUser__c 
                                      Where (Region__c =: managerRegion.Region__c AND id !=: userId)];
        return users;
    }
    
    public  List<Payment__c> getPayments(){
        
        return pays;
    }
    
    public PageReference setCurrentUserForPaymentHistory(){
        
        pays = [SELECT PaymentSumm__c, Date__c, Name 
                FROM Payment__c 
                WHERE ProjectUser__c =: currentUserId 
                ORDER BY Date__c DESC];
        return null;
    }
    
    public pageReference init(){
        
        userId = ApexPages.currentPage().getParameters().get('id');
        token = ApexPages.currentPage().getParameters().get('token');
        Boolean isValidToken = SalesforceWebToken.IsValidToken(token,userId);
        if(isValidToken){
            managerRegion = [SELECT Region__c, RecordTypeId 
                             FROM ProjectUser__c 
                             WHERE Id =: userId];
            String recordTypeName = Schema.SObjectType.ProjectUser__c.getRecordTypeInfosById().get(managerRegion.recordtypeid).getname();
            if(recordTypeName == 'Customer'){
                return  PageRoutes.autUserRoutes('/apex/detailUserPage', userId, token);
            }
            return null;
        }else{
            return PageRoutes.startPage();
        }
    }
    
    public pageReference home(){
        
       return  PageRoutes.autUserRoutes('/apex/detailUserPage', userId, token);
    }
}