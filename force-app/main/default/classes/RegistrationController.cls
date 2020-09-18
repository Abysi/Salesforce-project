public class RegistrationController {
    
    private Map<String,List<String>> dependentPicklistValuesMap{get;set;}
    private final String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
    private final String loginBusy = 'Choose other login';
    private final String invalidMail = 'Enter valid email';
    private final String invalidInputs = 'All fields required!';
    
    public String name{get;set;}
    public String login{get;set;}
    public String password{get;set;}
    public String selectedRegion{get;set;}
    public String selectedCity{get;set;}
    
    
    public RegistrationController(){
        
        dependentPicklistValuesMap = Utils.getDependentPicklistValues(ProjectUser__c.City__c);
        selectedRegion = 'Kyiv Region';  
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
    
    public pageReference Save(){
        
        if(customValidation()){
            Id recordTypeId = Schema.SObjectType.ProjectUser__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Blob signBlob = Blob.valueOf(password);
            String encryptedPassword = EncodingUtil.base64Encode(signBlob);
            ProjectUser__c user = new ProjectUser__c(Name = name, Login__c = login, Password__c = encryptedPassword,
                                                     Region__c = selectedRegion, City__c = selectedCity,
                                                     RecordTypeId = recordTypeId);
            database.SaveResult sr = Database.insert(user,false);
            if(sr.isSuccess()){
                Utils.SendMail(login, null);
                WebToken__C token = SalesforceWebToken.createWT(login, user);                
                return  PageRoutes.autUserRoutes('/apex/detailUserPage', user.Id, token.TokenForUser__c);
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, loginBusy));
                login = '';
                return null; 
            } 
        }else{
            return null;
        }
    }
    
    public Boolean customValidation(){
        
        Boolean isValid = true;
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(login);
        if(!MyMatcher.matches()){
            isValid = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, invalidMail));
        }
        if(String.isEmpty(name) || String.isEmpty(password)){
            isValid = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, invalidInputs));
        }
        return isValid;
    }
}