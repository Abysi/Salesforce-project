public class ChangeAdressController {
    
    public Map<String,List<String>> dependentPicklistValuesMap{get;set;}
    
    public String token{get;set;}
    public ProjectUser__c userInfo{get;set;}
    public String selectedRegion{get;set;}
    public String selectedCity{get;set;}
    
    
    public ProjectUser__c getUserInfo() {
        
        return userInfo;
    }
    
    public List<SelectOption> getRegionOptions(){
        
        List<SelectOption> regionOptions = new List<SelectOption>();
        for(String key : dependentPicklistValuesMap.keySet()){ 
            regionOptions.add(new SelectOption(key,key));
        }
        return regionOptions;
    }
    
    public List<SelectOption> getCityOptions(){
        
        List<SelectOption> cityOptions = new List<SelectOption>();
        for(String key : dependentPicklistValuesMap.get(selectedRegion)){ 
            cityOptions.add(new SelectOption(key,key));
        }
        return cityOptions;
    }
    
    public pageReference init(){
        
        Id keyId = ApexPages.currentPage().getParameters().get('id');
        token = ApexPages.currentPage().getParameters().get('token');
        Boolean isValidToken = SalesforceWebToken.IsValidToken(token,keyId);
        if(isValidToken){
            userInfo = [SELECT Id, Region__c, City__c 
                        FROM ProjectUser__c 
                        WHERE Id =: keyId]; 
            dependentPicklistValuesMap = Utils.getDependentPicklistValues(ProjectUser__c.City__c);
            selectedRegion = 'Kyiv Region';
            return null;
        }else{
            return PageRoutes.startPage();
        }
    }
    
    public pageReference Save(){
        
        userInfo.Region__c = selectedRegion;
        userInfo.City__c = selectedCity;
        update userInfo;
        return  PageRoutes.autUserRoutes('/apex/detailUserPage', userInfo.Id, token);
    }
}