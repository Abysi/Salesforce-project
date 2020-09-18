public class SalesforceWebToken {
    public static WebToken__C createWT(String sign,ProjectUser__c user){
        
        Blob signBlob = Blob.valueOf(sign);
        Blob secretBlob = Blob.valueOf(String.valueOf(SecurityPolicy__c.ACCESS_TOKEN_SECRET__c));
        Blob timeBlob = Blob.valueOf(String.valueOf(Date.today()));
        
        String token = EncodingUtil.base64Encode(signBlob)+
            		   EncodingUtil.base64Encode(secretBlob)+
            		   EncodingUtil.base64Encode(timeBlob);
        
        WebToken__C sfToken = new WebToken__C();
        sfToken.TokenForUser__c = token.replace('=', '');
        sfToken.idUserProject__c = user.Id;
        sfToken.ExpDateForToken__c = DateTime.now().addMinutes(30);
        
        insert sfToken;
        return sfToken;
    }
    public static Boolean IsValidToken(String sfToken,String idUser){
        
        Boolean isValidToken = false;
        List<WebToken__C> token = [SELECT ID, ExpDateForToken__c 
                                   FROM WebToken__C 
                                   WHERE (TokenForUser__c =: sfToken AND idUserProject__c =: idUser)];
        if(!token.isEmpty()){
            if(token[0].ExpDateForToken__c<DateTime.now()){
                delete token[0];
            }else{
                isValidToken = true;
            }
        } 
        return isValidToken;
    }
}