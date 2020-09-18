trigger ProjectUserTrigger on ProjectUser__c (before insert,before update) {
    for(ProjectUser__c projectUser:Trigger.new){
        string recordtypename=Schema.SObjectType.ProjectUser__c.getRecordTypeInfosById().get(projectUser.recordtypeid).getname(); 
        if(recordtypename=='Manager'){
            projectUser.Manager__c=true;
        }
        City__c city=[SELECT TaxElec__c,TaxGas__c,TaxWater__c 
                      FROM City__c 
                      WHERE Name= :projectUser.City__c];
        projectUser.cityTaxWater__c=city.TaxWater__c;
        projectUser.cityTaxGas__c=city.TaxGas__c;
        projectUser.CityTaxElec__c=city.TaxElec__c;
    }
}