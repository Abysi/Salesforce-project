@isTest
public class PageRoutesTest {
    
    @isTest
    public static void pageRefIsRegistration(){
        
        Test.startTest();
        PageReference response = PageRoutes.startPage();
        Test.stopTest();
        
        System.assert (response != null, 'Expected to have a non null page response');
        System.assert (response.getUrl() == '/apex/home');
    }
    @isTest
    public static void pageRefIsLogin(){
        
        Test.startTest();
        PageReference response = PageRoutes.autUserRoutes('/apex/login', 'userId', 'userToken');
        Test.stopTest();
        
        System.assert (response != null, 'Expected to have a non null page response');
        System.assert (response.getParameters().get('id') == 'userId');
        System.assert (response.getParameters().get('token') == 'userToken');
    }
    
}