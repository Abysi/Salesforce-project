public class MounthlyPaymentsController {
    
    public String token{get;set;}
    public ProjectUser__c userInfo{get;set;}
    public String payment{get;set;}
    
    public ProjectUser__c getUserInfo() {
        
        return userInfo;
    }
    
    public pageReference init(){
        
        Id keyId = ApexPages.currentPage().getParameters().get('id');
        token = ApexPages.currentPage().getParameters().get('token');
        Boolean isValidToken = SalesforceWebToken.IsValidToken(token,keyId);
        if(isValidToken){
            userInfo = [SELECT Id, Balance__c, Login__c 
                        FROM ProjectUser__c 
                        WHERE Id = :keyId]; 
            return null;
        }else{
            return PageRoutes.startPage();
        }
    }
    
    public pageReference  save(){
        
        if(customValidation()){
            Payment__c pay = new Payment__c();
            pay.Date__c = DateTime.now();
            pay.PaymentSumm__c = Decimal.valueOf(payment);
            pay.ProjectUser__c = userInfo.Id;
            insert pay;
            Utils.SendMail(userInfo.Login__c,'Successful pay ' + payment + '$');
            return  PageRoutes.autUserRoutes('/apex/detailUserPage', userInfo.Id, token);
        }else{
            Utils.SendMail(userInfo.Login__c, 'Problems with pay');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Payment consist letters or  less then 0'));
            return null;
        }
    }
    
    public Boolean customValidation(){
        
        Boolean isValid = true;
        if(String.isEmpty(payment) || !(payment.isNumeric()) || Decimal.valueOf(payment) <= 0 ){
            isValid = false;
        }
        return isValid;
    }
}