@isTest
public class LoginControllerTest {
    
    @testSetup
    public static void setup(){
        Id recordTypeIdCustomer = Schema.SObjectType.ProjectUser__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        ProjectUser__c testUser = new ProjectUser__c(Name = 'PositiveTest', Login__c = 'login@mail.ru', Password__c = 'MTIzNDU2',
                                                     Region__c = 'Kyiv Region', City__c = 'Kiev',
                                                     RecordTypeId = recordTypeIdCustomer);
        City__c city = new City__c(Name = 'Kiev', TaxWater__c = 1, TaxGas__c = 1, TaxElec__c = 1);
        
        insert city;
        insert testUser;
    }
    
    @isTest
    public static void pageRefCorrectCredentials(){
        
        LoginController lc = new LoginController();
        lc.login ='login@mail.ru';
        lc.password = '123456';
        
        Test.startTest();
        PageReference response=lc.Save();
        Test.stopTest();
        
        System.assert (response != null);
    }
    
     @isTest
    public static void incorrectLogin(){
        
        LoginController lc = new LoginController();
        lc.login = 'loginru';
        lc.password = '123456';
        
        Test.startTest();
        PageReference response = lc.Save();
        Test.stopTest();
        
        System.assert (response == null);
    }
     @isTest
    public static void dontHaveUserInDb(){
        
        LoginController lc = new LoginController();
        lc.login = 'loginru@mail.ru';
        lc.password = '123456';
        
        Test.startTest();
        PageReference response = lc.Save();
        Test.stopTest();
        
        System.assert (response == null);
    }
    @isTest
    public static void emptyPassword(){
        
        LoginController lc = new LoginController();
        lc.login = 'loginru@mail.ru';
        lc.password = '';
        
        Test.startTest();
        PageReference response = lc.Save();
        Test.stopTest();
        
        System.assert (response == null);
    }
}