public class ChangeRatesForRegionController {
    
    private ProjectUser__c userInfo;
    private Map<String,List<String>> dependentPicklistValuesMap{get;set;}
    private String token{get;set;}
    private String userId{get;set;}
    
    public String water{get;set;}
    public String gas{get;set;}
    public String elec{get;set;}
    
    
    public pageReference init(){
        
        userId = ApexPages.currentPage().getParameters().get('id');
        token = ApexPages.currentPage().getParameters().get('token');
        Boolean isValidToken = SalesforceWebToken.IsValidToken(token,userId);
        if(isValidToken){
            userInfo = [SELECT Region__c, Id, RecordTypeId 
                        FROM ProjectUser__c
                        WHERE Id =: userId];
            dependentPicklistValuesMap = Utils.getDependentPicklistValues(ProjectUser__c.City__c);
            String recordTypeName = Schema.SObjectType.ProjectUser__c.getRecordTypeInfosById().get(userInfo.recordtypeid).getname();
            if(recordTypeName == 'Customer'){
                return  PageRoutes.autUserRoutes('/apex/detailUserPage', userId, token);
            }
            return null;
        }else{
            return PageRoutes.startPage();
        }
    }
    
    public pageReference setNewRates(){
        
        if(customValidation()){
            List<String> cities = dependentPicklistValuesMap.get(userInfo.Region__c);
            List<City__c>cityToUpdate = new List<City__c>();
            for(String cityName : cities){
                for (City__c city : [SELECT Id, TaxElec__c, TaxGas__c, TaxWater__c 
                                     FROM City__c 
                                     WHERE Name =: cityName]){
                    city.TaxWater__c = Decimal.valueOf(water);
                    city.TaxGas__c = Decimal.valueOf(gas);
                    city.TaxElec__c = Decimal.valueOf(elec);
                    cityToUpdate.add(city);
                }
            }
            update cityToUpdate;
            updateUsersInfo();
            return  PageRoutes.autUserRoutes('/apex/detailUserPage', userInfo.id, token);
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Rates tax consist letters or less then 0'));
            return null;
        }
    }
    public void updateUsersInfo(){
        
        List<ProjectUser__c> allRecords = new List<ProjectUser__c>();
        allRecords = [SELECT id 
                      FROM ProjectUser__c];
        update allRecords;
    }
    
    public Boolean customValidation(){
        
        Boolean isValid = true;
        List<String> arr = new List<String>{water,gas,elec};
            for (String item : arr) {
                if(String.isEmpty(item) || !(item.isNumeric()) || Decimal.valueOf(item)<=0){
                    isValid = false;
                    break;
                }
            }
        return isValid;
    }   
}