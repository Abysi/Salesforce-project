@isTest
public class UtilsTest {
    @testSetup
    public static void setup(){
        
        Id recordTypeId = Schema.SObjectType.ProjectUser__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        ProjectUser__c user = new ProjectUser__c(Name = 'name', Login__c = 'login@mail.ru', Password__c = 'encryptedPassword',
                                                 Region__c = 'Kyiv Region', City__c = 'Kiev',
                                                 RecordTypeId = recordTypeId);
        City__c city = new City__c(Name = 'Kiev', TaxWater__c = 1, TaxGas__c = 1, TaxElec__c = 1);
        insert city;
        insert user;
    }
    
    @isTest
    public static void isSendMail(){
        
        Test.startTest();
        System.assert(Utils.SendMail('mailAddress@mail.ru', 'sad'));
        Test.stopTest();
    }
    
    @isTest
    public static void getRegionOptions(){
        
        ProjectUser__c testUser = [SELECT Id, City__c 
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'name' 
                                   LIMIT 1];
        Map<String,List<String>> dependentPicklistValuesMap = new Map<String,List<String>>();

        Test.startTest();
        RegistrationController rc = new RegistrationController();
        List<SelectOption> listOptions = rc.getRegionOptions();
        Test.stopTest();
        
        System.assert(!listOptions.isEmpty()); 
    }
    
    @isTest
    public static void getCityOptions(){
        
        ProjectUser__c testUser = [SELECT Id, City__c 
                                   FROM ProjectUser__c 
                                   WHERE Name =: 'name' 
                                   LIMIT 1];
        Map<String,List<String>> dependentPicklistValuesMap=new Map<String,List<String>>();

        Test.startTest();
        RegistrationController rc = new RegistrationController();
        List<SelectOption> listOptions = rc.getCityOptions();
        Test.stopTest();
        
        System.assert(!listOptions.isEmpty());
    }
}