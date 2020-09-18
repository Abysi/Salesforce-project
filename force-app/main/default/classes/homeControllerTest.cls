@isTest
public class homeControllerTest {
    @isTest
    public static void pageRefIsRegistration(){
        
        homeController hc = new homeController();
        
        Test.startTest();
        PageReference response=hc.registration();
        Test.stopTest();
        
        System.assert (response != null, 'Expected to have a non null page response');
        System.assert (response.getUrl() == '/apex/Registration');
    }
    @isTest
    public static void pageRefIsLogin(){
        
        homeController hc = new homeController();
        
        Test.startTest();
        PageReference response=hc.login();
        Test.stopTest();
        
        System.assert (response != null, 'Expected to have a non null page response');
        System.assert (response.getUrl() == '/apex/Login');
    }
    
}