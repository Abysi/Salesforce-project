@isTest
public class SalesforceWebTokenTest {
    
    @testSetup
    public static void setup(){
        
        List<ProjectUser__c> users = new List<ProjectUser__c>();
        SecurityPolicy__c customSetting = new SecurityPolicy__c();
        customSetting.ACCESS_TOKEN_SECRET__c = 'testValue';
        
        Id recordTypeIdCustomer = Schema.SObjectType.ProjectUser__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Id recordTypeIdManager = Schema.SObjectType.ProjectUser__c.getRecordTypeInfosByName().get('Manager').getRecordTypeId();
        
        ProjectUser__c testUser = new ProjectUser__c(Name = 'PositiveTest',Login__c = 'login@mail.ru',Password__c = 'encryptedPassword',
                                                     Region__c = 'Kyiv Region',City__c = 'Kiev',
                                                     RecordTypeId = recordTypeIdCustomer);
        
        users.add(testUser);
        ProjectUser__c testUserManager=new ProjectUser__c(Name = 'Test',Login__c = 'logi2n@mail.ru',Password__c = 'encryptedPassword',
                                                          Region__c = 'Kyiv Region',City__c = 'Kiev',
                                                          RecordTypeId = recordTypeIdManager);
        users.add(testUserManager);
        
        City__c city=new City__c(Name = 'Kiev',TaxWater__c = 1,TaxGas__c = 1,TaxElec__c = 1);
        
        insert city;
        insert users;
    }
    
    @isTest
    public static void testCreateWT(){
        
        ProjectUser__c testuser = [Select Login__c,Id From ProjectUser__c Where Name=:'PositiveTest'];
        Test.startTest();
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        Test.stopTest();
        
        System.assert (tokenObject != null);
    }
    @isTest
    public static void IsValidToken(){
        
        ProjectUser__c testuser = [Select Login__c,Id From ProjectUser__c Where Name=:'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        
        
        Test.startTest();
        
        Boolean positiveCase = SalesforceWebToken.IsValidToken(tokenObject.TokenForUser__c,testuser.Id);
        Boolean negativeCase = SalesforceWebToken.IsValidToken(tokenObject.TokenForUser__c,'testuser.Id');
        Test.stopTest();
        
        
        System.assertEquals(true, positiveCase);
        System.assertEquals(false, negativeCase);
    }
}