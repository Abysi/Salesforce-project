public class LoginController {
    
    private String encryptedPassword{get;set;}
    private final String incorrectInput = 'Inncorect login or password!';
    private final String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
    
    public String login{get;set;}
    public String password{get;set;}
    
    public pageReference Save(){
        
        Blob signBlob = Blob.valueOf(password);
        encryptedPassword = EncodingUtil.base64Encode(signBlob);
        if(customValidation()){
            List<ProjectUser__c> user = [SELECT Id 
                                         FROM ProjectUser__c 
                                         WHERE (Login__c =: login AND Password__c =: encryptedPassword)];
            if(!user.isEmpty()){
                WebToken__C token = SalesforceWebToken.createWT(login, user[0]);
                return  PageRoutes.autUserRoutes('/apex/detailUserPage', user[0].Id, token.TokenForUser__c);
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, incorrectInput));
                return null;
            } 
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, incorrectInput));
            return null;
        }
    }
    
    public Boolean customValidation(){
        
        Boolean isValid = true;
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(login);
        if(!MyMatcher.matches()){
            isValid = false;
        }
        if(String.isEmpty(login) || String.isEmpty(password)){
            isValid = false;
        }
        return isValid;
    }
}