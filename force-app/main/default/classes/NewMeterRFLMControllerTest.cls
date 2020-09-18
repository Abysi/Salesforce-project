@isTest
public class NewMeterRFLMControllerTest {
    
    @testSetup
    public static void setup(){
        SecurityPolicy__c customSetting = new SecurityPolicy__c();
        customSetting.ACCESS_TOKEN_SECRET__c = 'testValue';
        Id recordTypeIdCustomer = Schema.SObjectType.ProjectUser__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        ProjectUser__c testUser = new ProjectUser__c(Name = 'PositiveTest', Login__c = 'login@mail.ru', Password__c = 'MTIzNDU2',
                                                     Region__c = 'Kyiv Region', City__c = 'Kiev',
                                                     RecordTypeId = recordTypeIdCustomer);
        City__c city=new City__c(Name = 'Kiev', TaxWater__c = 1, TaxGas__c = 1, TaxElec__c = 1);
        
        insert city;
        insert testUser;
    }
    
    @isTest
    public static void correctUser(){
        ProjectUser__c testuser = [SELECT Login__c, Id 
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        ApexPages.currentPage().getParameters().put('token', tokenObject.TokenForUser__c);
        
        Test.startTest();
        NewMeterReadingsForLastMonthController mt = new NewMeterReadingsForLastMonthController();
        PageReference response = mt.init();
        Test.stopTest();
        
        System.assert (response == null);
    }
    @isTest
    public static void userDontHaveAccess(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id 
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        
        Test.startTest();
        NewMeterReadingsForLastMonthController mt = new NewMeterReadingsForLastMonthController();
        PageReference response = mt.init();
        Test.stopTest();
        
        System.assert (response != null);
    }
    @isTest
    public static void correctFields(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id 
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        ApexPages.currentPage().getParameters().put('token', tokenObject.TokenForUser__c);
        
        Test.startTest();
        NewMeterReadingsForLastMonthController mt = new NewMeterReadingsForLastMonthController();
        mt.init();
        mt.elec = '2';
        mt.gas = '2';
        mt.water = '2';
        PageReference response = mt.save();
        Test.stopTest();
        
        System.assert (response != null);
    }
    @isTest
    public static void incorrectFields(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id 
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        ApexPages.currentPage().getParameters().put('token', tokenObject.TokenForUser__c);
        
        Test.startTest();
        NewMeterReadingsForLastMonthController mt = new NewMeterReadingsForLastMonthController();
        mt.init();
        mt.elec = '';
        mt.gas = '';
        mt.water = '2';
        PageReference response = mt.save();
        Test.stopTest();
        
        System.assert (response == null);
    }
    @isTest
    public static void getUser(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id 
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        ApexPages.currentPage().getParameters().put('token', tokenObject.TokenForUser__c);
        
        Test.startTest();
        NewMeterReadingsForLastMonthController mt = new NewMeterReadingsForLastMonthController();
        mt.init();
        ProjectUser__c us = mt.getuserInfo();
        PageReference response = mt.save();
        Test.stopTest();
        
        System.assert (us != null);
    }
}