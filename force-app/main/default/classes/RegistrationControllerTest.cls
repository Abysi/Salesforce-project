@isTest
public class RegistrationControllerTest {
    @testSetup
    public static void setup(){
        Id recordTypeId = Schema.SObjectType.ProjectUser__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        ProjectUser__c user = new ProjectUser__c(Name = 'name', Login__c = 'login@mail.ru', Password__c = 'encryptedPassword',
                                                 Region__c = 'Kyiv Region', City__c = 'Kiev',
                                                 RecordTypeId = recordTypeId);
        City__c city=new City__c(Name = 'Kiev', TaxWater__c = 1, TaxGas__c = 1, TaxElec__c = 1);
        insert city;
        insert user;
    }
    
    @isTest
    public static void pageRefCorrectCredentials(){
        
        RegistrationController lc = new RegistrationController();
        lc.name = 'Dsa';
        lc.selectedCity = 'Kiev';
        lc.selectedRegion = 'Kyiv Region';
        lc.login = 'login@mail.ru';
        lc.password = '123456';
        
        Test.startTest();
        PageReference response=lc.Save();
        Test.stopTest();
        
        System.assert (response == null);
    }
    @isTest
    public static void pageRefIncorrectMail(){
        
        RegistrationController lc = new RegistrationController();
        lc.name = 'Dsa';
        lc.selectedCity = 'Kiev';
        lc.selectedRegion = 'Kyiv Region';
        lc.login= 'login@ru';
        lc.password = '123456';
        
        Test.startTest();
        PageReference response = lc.Save();
        Test.stopTest();
        
        System.assert (response == null);
    }
    @isTest
    public static void pageRefEmptyPassword(){
        RegistrationController lc = new RegistrationController();
        lc.name = 'Dsa';
        lc.selectedCity = 'Kiev';
        lc.selectedRegion = 'Kyiv Region';
        lc.login = 'login@ru';
        lc.password = '';
        
        Test.startTest();
        PageReference response = lc.Save();
        Test.stopTest();
        
        System.assert (response == null);
    }
}