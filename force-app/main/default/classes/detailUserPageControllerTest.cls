@isTest
public class detailUserPageControllerTest {
    
    @testSetup
    public static void setup(){
        
        SecurityPolicy__c customSetting = new SecurityPolicy__c();
        customSetting.ACCESS_TOKEN_SECRET__c = 'testValue';
        Id recordTypeIdCustomer = Schema.SObjectType.ProjectUser__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        ProjectUser__c testUser = new ProjectUser__c(Name = 'PositiveTest', Login__c = 'login@mail.ru', Password__c = 'MTIzNDU2',
                                                     Region__c = 'Kyiv Region', City__c = 'Kiev',
                                                     RecordTypeId = recordTypeIdCustomer);
        City__c city = new City__c(Name = 'Kiev', TaxWater__c = 1, TaxGas__c = 1, TaxElec__c = 1);
        
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
        detailUserPageController mt = new detailUserPageController();
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
        detailUserPageController mt = new detailUserPageController();
        PageReference response = mt.init();
        Test.stopTest();
        
        System.assert (response != null);
    }
    
    @isTest
    public static void getUsers(){
        
        Test.startTest();
        detailUserPageController mt = new detailUserPageController();
        mt.init();
        ProjectUser__c userInfo = mt.getUserInfo();
        Test.stopTest();
        
        System.assert (userInfo == null);
    }
    
    
    @isTest
    public static void changeAddress(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id 
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        ApexPages.currentPage().getParameters().put('token', tokenObject.TokenForUser__c);
        
        Test.startTest();
        detailUserPageController mt = new detailUserPageController();
        mt.init();
        PageReference response = mt.changeAddress();
        Test.stopTest();
        
        System.assert (response != null);
    }
     @isTest
    public static void sendMeterReading(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        ApexPages.currentPage().getParameters().put('token', tokenObject.TokenForUser__c);
        
        Test.startTest();
        detailUserPageController mt = new detailUserPageController();
        mt.init();
        PageReference response = mt.sendMeterReading();
        Test.stopTest();
        
        System.assert (response != null);
    }
     @isTest
    public static void payToBill(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        ApexPages.currentPage().getParameters().put('token',tokenObject.TokenForUser__c);
        
        Test.startTest();
        detailUserPageController mt = new detailUserPageController();
        mt.init();
        PageReference response = mt.payToBill();
        Test.stopTest();
        
        System.assert (response != null);
    }
     @isTest
    public static void paymentReport(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        ApexPages.currentPage().getParameters().put('token', tokenObject.TokenForUser__c);
        
        Test.startTest();
        detailUserPageController mt = new detailUserPageController();
        mt.init();
        PageReference response = mt.paymentReport();
        Test.stopTest();
        
        System.assert (response != null);
    }
     @isTest
    public static void contactManager(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        ApexPages.currentPage().getParameters().put('token', tokenObject.TokenForUser__c);
        
        Test.startTest();
        detailUserPageController mt = new detailUserPageController();
        mt.init();
        PageReference response = mt.contactManager();
        Test.stopTest();
        
        System.assert (response != null);
    }
     @isTest
    public static void userPaymentHistory(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        ApexPages.currentPage().getParameters().put('token', tokenObject.TokenForUser__c);
        
        Test.startTest();
        detailUserPageController mt = new detailUserPageController();
        mt.init();
        PageReference response = mt.userPaymentHistory();
        Test.stopTest();
        
        System.assert (response != null);
    }
     @isTest
    public static void changeUserBill(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        ApexPages.currentPage().getParameters().put('token', tokenObject.TokenForUser__c);
        
        Test.startTest();
        detailUserPageController mt = new detailUserPageController();
        mt.init();
        PageReference response = mt.changeUserBill();
        Test.stopTest();
        
        System.assert (response != null);
    }
     @isTest
    public static void changeRegionRates(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        ApexPages.currentPage().getParameters().put('token', tokenObject.TokenForUser__c);
        
        Test.startTest();
        detailUserPageController mt = new detailUserPageController();
        mt.init();
        PageReference response = mt.changeRegionRates();
        Test.stopTest();
        
        System.assert (response != null);
    }
   
    
    
}