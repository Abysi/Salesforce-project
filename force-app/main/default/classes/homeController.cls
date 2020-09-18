public class homeController {
    
    public pageReference registration(){
        
        PageReference pageRef = new PageReference('/apex/Registration');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public pageReference login(){
        
        PageReference pageRef = new PageReference('/apex/Login');
        pageRef.setRedirect(true);
        return pageRef;
    }
}