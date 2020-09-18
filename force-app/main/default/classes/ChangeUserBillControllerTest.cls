@isTest
public class ChangeUserBillControllerTest {
    
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
        ChangeUserBillController mt = new ChangeUserBillController();
        PageReference response = mt.init();
        Test.stopTest();
        
        System.assert (response != null);
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
        ChangeUserBillController mt = new ChangeUserBillController();
        PageReference response = mt.init();
        Test.stopTest();
        
        System.assert (response != null);
    }
    
    @isTest
    public static void getUsers(){
        
        Test.startTest();
        ChangeUserBillController mt = new ChangeUserBillController();
        mt.managerUser = [SELECT Login__c, Id, Region__c 
                          FROM ProjectUser__c 
                          WHERE Name =: 'PositiveTest'];
        List<ProjectUser__c> users = mt.getUsers();
        Test.stopTest();
        
        System.assert (users != null);
    }
    
    @isTest
    public static void setCurrentUserForPenalty(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id 
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        
        Test.startTest();
        ChangeUserBillController mt = new ChangeUserBillController();
        mt.currentUserId = testuser.id;
        PageReference response = mt.setCurrentUserForPenalty();
        Test.stopTest();
        
        System.assert (response == null);
    }
    
    @isTest
    public static void addPenaltyForUserWithCorrectPenalty(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id 
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        
        Test.startTest();
        ChangeUserBillController mt = new ChangeUserBillController();
        mt.init();
        mt.penalty = '2';
        PageReference response = mt.addPenaltyForUser();
        Test.stopTest();
        
        System.assert (response == null);
    }
    @isTest
    public static void addPenaltyForUserWithIncorrectPenalty(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id 
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',testuser.Id);
        ApexPages.currentPage().getParameters().put('token',tokenObject.TokenForUser__c);
        
        Test.startTest();
        ChangeUserBillController mt = new ChangeUserBillController();
        mt.init();
        mt.penalty = '';
        PageReference response = mt.addPenaltyForUser();
        Test.stopTest();
        
        System.assert (response == null);
    }
    @isTest
    public static void addPenaltyForUserWithcorrectUser(){
        
        ProjectUser__c testuser = [SELECT Login__c, Id 
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id' ,testuser.Id);
        ApexPages.currentPage().getParameters().put('token', tokenObject.TokenForUser__c);
        
        Test.startTest();
        ChangeUserBillController mt = new ChangeUserBillController();
        mt.init();
        mt.penalty = '2';
        mt.currentUser=testuser;
        PageReference response = mt.addPenaltyForUser();
        Test.stopTest();
        
        System.assert (response != null);
    } 
}