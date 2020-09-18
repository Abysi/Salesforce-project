public class detailUserPageController {
    
    private String token{get;set;}
    
    public ProjectUser__c userInfo{get;set;}
    public String recordTypeName{get;set;}
    
    public ProjectUser__c getUserInfo() {
        
        return userInfo;
    }
    
    public pageReference init(){
        
        Id keyId = ApexPages.currentPage().getParameters().get('id');
        token = ApexPages.currentPage().getParameters().get('token');
        Boolean isValidToken = SalesforceWebToken.IsValidToken(token,keyId);
        if(isValidToken){
            userInfo = [SELECT Id, Name, Login__c, Region__c, City__c, CityTaxElec__c, cityTaxGas__c, cityTaxWater__c,
                        	   Mater_Water__c, Meter_Elec__c, Meter_Gas__c, Balance__c,
                        	   To_Pay_at_lastDatOfMonth__c, PenaltyFromManager__c, RecordTypeId
                        FROM ProjectUser__c 
                        WHERE Id =: keyId];
            recordTypeName = Schema.SObjectType.ProjectUser__c.getRecordTypeInfosById().get(userInfo.recordtypeid).getname();
            return null;
        }else{
            return PageRoutes.startPage();
        }
    }
    
    public pageReference changeAddress(){
        
        return PageRoutes.autUserRoutes('/apex/ChangeAdress', userInfo.Id, token);
    }
    
    public pageReference sendMeterReading(){
        
        return PageRoutes.autUserRoutes('/apex/NewMeterReadingsForLastMounth', userInfo.Id, token);
    }
    
    public pageReference payToBill(){
        
        return PageRoutes.autUserRoutes('/apex/MounthlyPayments', userInfo.Id, token);
    }
    
    public pageReference paymentReport(){
        
        return PageRoutes.autUserRoutes('/apex/PaymentHistory', userInfo.Id, token);
    }
    
    public pageReference contactManager(){
        
        return PageRoutes.autUserRoutes('/apex/ContactManager', userInfo.Id, token); 
    }
    
    public pageReference userPaymentHistory(){
        
        return PageRoutes.autUserRoutes('/apex/UsersPaymentHistory', userInfo.Id, token);
    }
    
    public pageReference changeUserBill(){
        
        return PageRoutes.autUserRoutes('/apex/ChangeUserBill', userInfo.Id, token);
    }
    
    public pageReference changeRegionRates(){
        
        return PageRoutes.autUserRoutes('/apex/ChangeRatesForRegion', userInfo.Id, token);
    }
}