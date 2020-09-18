@isTest
public class ChangeAdressControllerTest {
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
    public static void correctToken(){
        
       ProjectUser__c testuser = [SELECT Login__c, Id 
                                  FROM ProjectUser__c 
                                  WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(testUser.Login__c, testUser);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',testuser.Id);
        ApexPages.currentPage().getParameters().put('token',tokenObject.TokenForUser__c);
        ChangeAdressController mc = new ChangeAdressController();
        mc.token=tokenObject.TokenForUser__c;
        mc.userInfo=testuser;
    
        Test.startTest();
        PageReference response = mc.init();
        Test.stopTest();
        
        System.assert (response == null);
    }
    
      @isTest
    public static void incorrectToken(){
        
        ProjectUser__c user = [SELECT Id, Login__c 
                               FROM ProjectUser__c 
                               WHERE Name =: 'PositiveTest'];
        WebToken__C tokenObject = SalesforceWebToken.createWT(user.Login__c, user);
        PageReference myVfPage = Page.NewMeterReadingsForLastMounth;
        Test.setCurrentPage(myVfPage);
        ApexPages.currentPage().getParameters().put('id',user.Id);
        ChangeAdressController mc = new ChangeAdressController();
        mc.token = tokenObject.TokenForUser__c;
        mc.userInfo = user;
    
        Test.startTest();
        PageReference response = mc.init();
        Test.stopTest();
        
        System.assert (response != null);
    }
    
    @isTest
    public static void getUserInfo(){
        
        Test.startTest();
        ChangeAdressController mc = new ChangeAdressController();
        ProjectUser__c user = mc.getUserInfo();
        Test.stopTest();
        
        system.assert(user == null);
    }
    
     @isTest
    public static void correctCredentials(){
        
        Test.startTest();
        ChangeAdressController mc = new ChangeAdressController();
        mc.selectedCity = 'Kiev';
        mc.selectedRegion = 'Kyiv Region';
        mc.userInfo = [SELECT Id, Login__c 
                       FROM ProjectUser__c 
                       WHERE Name =: 'PositiveTest'];
        PageReference response = mc.Save();
        Test.stopTest();
        
        system.assert(response != null);
    }
    
    @isTest
    public static void getRegionOptions(){
        
        ChangeAdressController mc = new ChangeAdressController();
        mc.dependentPicklistValuesMap = Utils.getDependentPicklistValues(ProjectUser__c.City__c);
        
        Test.startTest();
        List<SelectOption> regionOptions = mc.getRegionOptions();
        Test.stopTest();
        
        system.assert(regionOptions != null);
    }
    
    @isTest
    public static void getCityOptions(){
        
        ChangeAdressController mc = new ChangeAdressController();
        mc.dependentPicklistValuesMap = Utils.getDependentPicklistValues(ProjectUser__c.City__c);
        mc.selectedRegion = 'Kyiv Region';
        
        Test.startTest();
        List<SelectOption> cityOptions = mc.getCityOptions();
        Test.stopTest();
        
        system.assert(cityOptions != null);
    }
}