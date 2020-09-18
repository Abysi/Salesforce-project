public class NewMeterReadingsForLastMonthController {
    
    private ProjectUser__c userInfo;
    private String token{get;set;}
    private final String incorrectMeters = 'Metter must be more or equal previous meter readings';
    private final String inputEmpty ='All fields required!';
    
    public String water{get;set;}
    public String gas{get;set;}
    public String elec{get;set;}
    
    public ProjectUser__c getuserInfo() {
        
        return userInfo;
    }
    
    public pageReference init(){
        
        Id keyId = ApexPages.currentPage().getParameters().get('id');
        token = ApexPages.currentPage().getParameters().get('token');
        Boolean isValidToken = SalesforceWebToken.IsValidToken(token,keyId);
        if(isValidToken){
            userInfo = [SELECT Mater_Water__c, Meter_Elec__c, Meter_Gas__c 
                        FROM ProjectUser__c 
                        WHERE Id =: keyId];
            return null;
        }else{
           return PageRoutes.startPage();
        }
    }
    
    public pageReference  save(){
        
        if(customValidation()){
            userInfo.Mater_Water__c = Decimal.valueOf(water) ;
            userInfo.Meter_Elec__c = Decimal.valueOf(elec);
            userInfo.Meter_Gas__c = Decimal.valueOf(gas);
            database.SaveResult sr = Database.update(userInfo,false);
            if(sr.isSuccess()){
                return  PageRoutes.autUserRoutes('/apex/detailUserPage', userInfo.Id, token);
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, incorrectMeters));
                return null; 
            } 
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, inputEmpty));
            return null;
        } 
    }
    
    public Boolean customValidation(){
        
        Boolean isValid = true;
        if(String.isEmpty(water) || String.isEmpty(gas) || String.isEmpty(elec)){
            isValid = false;
        }
        return isValid;
    }
}