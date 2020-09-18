@isTest
public class MounthlyPaymentsControllerTest {
    @testSetup
    public static void setup(){
        Id recordTypeId = Schema.SObjectType.ProjectUser__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        ProjectUser__c user = new ProjectUser__c(Name = 'name', Login__c = 'login@mail.ru', Password__c = 'encryptedPassword',
                                                 Region__c = 'Kyiv Region', City__c = 'Kiev',
                                                 RecordTypeId = recordTypeId);
        City__c city = new City__c(Name = 'Kiev', TaxWater__c = 1, TaxGas__c = 1, TaxElec__c = 1);
        insert city;
        insert user;
        WebToken__C tokenObject = SalesforceWebToken.createWT(user.Login__c, user);  
    }
    
    @isTest
    public static void incorrectToken(){
        
        ProjectUser__c user = [SELECT Id, Login__c 
                               FROM ProjectUser__c 
                               WHERE Name =: 'name'];
        WebToken__C tokenObject = [SELECT TokenForUser__c 
                                   FROM WebToken__C 
                                   LIMIT 1];
        MounthlyPaymentsController mc = new MounthlyPaymentsController();
        mc.token = tokenObject.TokenForUser__c;
        mc.userInfo = user;
    
        Test.startTest();
        mc.init();
        Test.stopTest();
    }
    @isTest
    public static void getUserInfo(){
        
        Test.startTest();
        MounthlyPaymentsController mc = new MounthlyPaymentsController();
        ProjectUser__c user = mc.getUserInfo();
        Test.stopTest();
        
        system.assert(user == null);
    }
    @isTest
    public static void correctPayment(){
        
        ProjectUser__c user = [SELECT Id,Login__c 
                               FROM ProjectUser__c 
                               WHERE Name =:'name'];
        WebToken__C tokenObject = [SELECT TokenForUser__c 
                                   FROM WebToken__C 
                                   LIMIT 1];
        MounthlyPaymentsController mc = new MounthlyPaymentsController();
        mc.token = tokenObject.TokenForUser__c;
        mc.userInfo = user;
        mc.payment = '21';
        
        Test.startTest();
        mc.save();
        Test.stopTest();
    }
    
    @isTest
    public static void incorrectPayment(){
        
        ProjectUser__c user = [SELECT Id,Login__c 
                               FROM ProjectUser__c 
                               WHERE Name =:'name'];
        WebToken__C tokenObject = [SELECT TokenForUser__c 
                                   FROM WebToken__C 
                                   LIMIT 1];
        MounthlyPaymentsController mc = new MounthlyPaymentsController();
        mc.token = tokenObject.TokenForUser__c;
        mc.userInfo = user;
        mc.payment = '';
        
        Test.startTest();
        mc.save();
        Test.stopTest();
    }
}