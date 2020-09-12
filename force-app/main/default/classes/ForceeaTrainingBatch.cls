public with sharing class ForceeaTrainingBatch implements Database.Batchable<SObject>, Database.Stateful {

    public ForceeaTrainingBatch(Map<String, FObject> template, Boolean allOrNone) {
        if (Test.isRunningTest()) {
            createTestRecords(template, allOrNone);
        }
        // code for standard constructor
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = String.escapeSingleQuotes('SELECT Name, TestText__c FROM FObjectOne__c');
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<SObject> scope) {
        if (Test.isRunningTest()) { // modify scope when testing
            scope = FObject.getInsertedRecords(FObjectOne__c.SObjectType);
        }

        List<FObjectOne__c> records = (List<FObjectOne__c>) scope;
        doSomething(records); // code to process records
    }

    public void finish(Database.BatchableContext context) {
    }

    /* METHODS */

    private void createTestRecords(Map<String, FObject> template, Boolean allOrNone) {
        FObject.setDmlOptimizer(true);
        FObject.insertRecordsFromTemplate(template, allOrNone);
    }

    private void doSomething(List<FObjectOne__c> records) {
        for (FObjectOne__c record : records) {
            record.TestTextRequired__c = 'test!';
        }
        update records;
    }

}
