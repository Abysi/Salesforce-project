public class ChangeUserBillController {
    
    
    private String token{get;set;}
    private String userId{get;set;}
    
    public ProjectUser__c managerUser{get;set;}
    public String currentUserId{get;set;}
    public ProjectUser__c currentUser{get;set;}
    public String penalty{get;set;}
    public Boolean IsUserSelect{get;set;}
    
    
    public pageReference init(){
        
        userId = ApexPages.currentPage().getParameters().get('id');
        token = ApexPages.currentPage().getParameters().get('token');
        Boolean isValidToken = SalesforceWebToken.IsValidToken(token,userId);
        if(isValidToken){
            IsUserSelect = false;
            managerUser = [SELECT Region__c, RecordTypeId 
                           FROM ProjectUser__c 
                           WHERE Id =: userId];
            String recordTypeName = Schema.SObjectType.ProjectUser__c.getRecordTypeInfosById().get(managerUser.recordtypeid).getname();
            if(recordTypeName == 'Customer'){
                return  PageRoutes.autUserRoutes('/apex/detailUserPage', userId, token);
            }
            return null;
        }else{
            return PageRoutes.startPage();
        }
    }
    
    public  List<ProjectUser__c> getUsers(){
        
        List<ProjectUser__c> users = [SELECT Id, Name, Region__c 
                                      FROM ProjectUser__c 
                                      WHERE (Region__c =: managerUser.Region__c AND id !=: userId)];
        return users;
    }
    
    public pageReference setCurrentUserForPenalty(){
        
        IsUserSelect = true;
        currentUser = [Select Id, Name, PenaltyFromManager__c 
                       FROM ProjectUser__c 
                       WHERE Id =: currentUserId];
        return null;
    }
    
    public pageReference addPenaltyForUser(){
        if(customValidation()){
            if(currentUser != null){
                currentUser.PenaltyFromManager__c = Decimal.valueOf(penalty);
                update currentUser;
                return  PageRoutes.autUserRoutes('/apex/detailUserPage', managerUser.Id, token);
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Choose user '));
                return null;
            }}
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Input contains numbers'));
            return null;
        }
    }
    
    public Boolean customValidation(){
        
        Boolean isValid = true;
        if(!(penalty.isNumeric())){
            isValid = false;
        }
        return isValid;
    }
}