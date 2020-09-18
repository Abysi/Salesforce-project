public class PageRoutes {
    
    public static pageReference autUserRoutes(String pageReference,String paramUserId,String paramSfToken){
        
        PageReference pageRef = new PageReference(pageReference);
        pageRef.getParameters().put('id',paramUserId);
        pageRef.getParameters().put('token',paramSfToken);
        pageRef.setRedirect(true);
        return pageRef;
    }
    public static pageReference startPage(){
        
        PageReference pageRef = new PageReference('/apex/home');
        pageRef.setRedirect(true);
        return pageRef;
    }
}