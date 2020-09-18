@isTest
public class PaymentHistoryControllerTest {
    
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
                                   Where Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        ApexPages.currentPage().getParameters().put('token',tokenObject.TokenForUser__c);
        
        Test.startTest();
        PaymentHistoryController mt = new PaymentHistoryController();
        PageReference response = mt.init();
        Test.stopTest();
        
        System.assert (response == null);
    }
    
    @isTest
    public static void userDontHaveAccess(){
        ProjectUser__c testuser = [SELECT Login__c, Id 
                                   FROM ProjectUser__c 
                                   Where Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id', testuser.Id);
        
        Test.startTest();
        PaymentHistoryController mt = new PaymentHistoryController();
        PageReference response = mt.init();
        Test.stopTest();
        
        System.assert (response != null);
    }
    @isTest
    public static void getPayments(){
        
        Test.startTest();
        PaymentHistoryController mt = new PaymentHistoryController();
        List<Payment__c> payments = mt.getPayments();
        Test.stopTest();
        
        System.assert (payments == null);
    }
    
    @isTest
    public static void pageRefHome(){
        
        Test.startTest();
        PaymentHistoryController mt = new PaymentHistoryController();
        PageReference response = mt.home();
        Test.stopTest();
        
        System.assert (response != null);
    }  
}