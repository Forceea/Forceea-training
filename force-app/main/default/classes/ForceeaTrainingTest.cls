@IsTest
public class ForceeaTrainingTest {

    // Demonstrates: value argument with space, ( and )
    @IsTest
    public static void demoArguments() {
        FObject.setGlobalVerbose('debug');

        FObject obj = new FObject(FObjectOne__c.SObjectType, 10)
            .setDefinition(FObjectOne__c.TestText__c, 'random type(number) from(10) to(100) scale(0)')
            .setDefinition(FObjectOne__c.TestText__c, 'static value(" record(s)")')
            .createRecords();

        System.assert(FObject.processIsValid(), 'Found errors');
    }

    // Demonstrates: function-add
    @IsTest
    public static void demoFunctionAdd() {
        FObject.setGlobalVerbose('debug');
        FObject.setGlobalVariable('today', Date.today());

        FObject obj1 = new FObject(FObjectOne__c.SObjectType, 10)
            .setDefinition('$Days', 'random type(number) from(-365) to(0) scale(0)')
            .setDefinition(FObjectOne__c.TestDate__c, 'static value({@today})')
            .setDefinition(FObjectOne__c.TestDate__c, 'function-add field($Days)')
            .createRecords();

        // solution without function-add
        FObject obj2 = new FObject(FObjectOne__c.SObjectType, 10)
            .setVariable('DateFrom', Date.today().addDays(-365))
            .setDefinition(FObjectOne__c.TestDate__c, 'random type(date) from({@DateFrom}) to({@today})')
            .createRecords();

        System.assert(FObject.processIsValid(), 'Found errors');
    }

    // Demonstrates: ID mocking
    @IsTest
    public static void demoIdMocking() {
        FObject.setGlobalVerbose('debug');
        FObject.setGlobalMocking(true);

        Map<String, FObject> template = ForceeaTrainingDataFactory.templateBigOpportunitiesWithMajorAccounts();

        template.get(ForceeaTrainingDataFactory.ACCOUNTS)
            .setNumberOfRecords(10)
            .setDefinition(Account.Industry, 'random type(picklist) except(Energy,Chemicals)');
        template.get(ForceeaTrainingDataFactory.OPPORTUNITIES)
            .setNumberOfRecords(100);
        FObject.insertRecordsFromTemplate(template, true);

        System.assert(FObject.processIsValid(), 'Found errors');
    }

    // Demonstrates: inserting accounts and contacts
    @IsTest
    public static void demoInsertContactsWithMajorAccounts() {
        FObject.setGlobalVerbose('debug');
        Map<String, FObject> template = ForceeaTrainingDataFactory.templateContactsWithMajorAccounts();

        template.get(ForceeaTrainingDataFactory.ACCOUNTS)
            .setNumberOfRecords(10)
            .setDefinition(Account.Industry, 'random type(picklist) except(Energy,Chemicals)');
        template.get(ForceeaTrainingDataFactory.CONTACTS)
            .setNumberOfRecords(100);

        FObject.insertRecordsFromTemplate(template, true);
    }

    // Demonstrates: inserting accounts, contacts and opportunities
    @IsTest
    public static void demoInsertAccountsContactsOpportunities1() {
        FObject.setGlobalVerbose('debug');

        Map<String, FObject> template = new Map<String, FObject>();
        template.putAll(ForceeaTrainingDataFactory.templateContactsWithMajorAccounts());
        template.putAll(ForceeaTrainingDataFactory.templateBigOpportunitiesWithMajorAccounts());

        template.get(ForceeaTrainingDataFactory.ACCOUNTS)
            .setNumberOfRecords(10)
            .setDefinition(Account.Industry, 'random type(picklist) except(Energy,Chemicals)');

        template.get(ForceeaTrainingDataFactory.CONTACTS)
            .setNumberOfRecords(100);

        template.get(ForceeaTrainingDataFactory.OPPORTUNITIES)
            .setNumberOfRecords(100)
            .deleteDefinitions(Opportunity.StageName)
            .setDefinition(Opportunity.StageName, 'static value(Closed Won)');

        FObject.insertRecordsFromTemplate(template, true);
    }

    // Demonstrates: permutations with serial list
    @IsTest
    public static void demoPermutations1() {
        FObject.setGlobalVerbose('debug');

        FObject obj = new FObject(FObjectOne__c.SObjectType, 100) // the number of records is ignored
            .setNumberOfRecords('auto')
            .setDefinition(FObjectOne__c.TestText__c,
                'serial type(list) value(PER,MON,LYC,TYR,LOT) mode(permutation)') // 5 items
            .setDefinition(FObjectOne__c.TestText__c,
                'serial type(list) value(AM,OP,ES) mode(permutation)') // 3 items
            .setDefinition(FObjectOne__c.TestText__c,
                'serial type(list) value(OL,IN,AR) mode(permutation)'); // 3 items

        // 5 x 3 x 3 = 45 records
        for (FObjectOne__c objRecord : (List<FObjectOne__c>) obj.getRecords()) {
            System.debug(objRecord.TestText__c);
        }

        System.assert(FObject.processIsValid(), 'Found errors');
    }

    // Demonstrates: permutations with serial list and serial lookup
    @IsTest
    public static void demoPermutations2() {
        FObject.setGlobalVerbose('debug');

        FObject obj2 = new FObject(FObjectTwo__c.SObjectType, 10)
            .setDefinition(FObjectTwo__c.TestText__c, 'static value(Test-)')
            .setDefinition(FObjectTwo__c.TestText__c, 'serial type(number) from(1) step(1) scale(0)');
        obj2.insertRecords(true);

        FObject obj1 = new FObject(FObjectOne__c.SObjectType)
            .setNumberOfRecords('auto')
            .setDefinition(FObjectOne__c.TestText__c, 'serial type(list) value(A,B,C) mode(permutation)')
            .setDefinition(FObjectOne__c.TestText__c, 'serial type(list) value(1,2,3) mode(permutation)')
            .setDefinition(FObjectOne__c.TestLookup__c, 'serial lookup(FObjectTwo__c) mode(permutation) source(forceea)');

        // 10 lookup records x 3 x 3 = 90 records
        for (FObjectOne__c objRecord : (List<FObjectOne__c>) obj1.getRecords()) {
            System.debug(objRecord.TestLookup__c + ' - ' + objRecord.TestText__c);
        }

        System.assert(FObject.processIsValid(), 'Found errors');
    }

    // Demonstrates: variables
    @IsTest
    public static void demoVariables() {
        FObject.setGlobalVerbose('debug');
        FObject.setGlobalVariable('today', Date.today());

        FObject obj = new FObject(FObjectOne__c.SObjectType, 10)
            .setVariable('myDataFactory', 'Forceea')
            .setDefinition(FObjectOne__c.TestText__c,
                'random type(list) value(is true, today is {@today}, my data Factory is {@myDataFactory})')
            .createRecords();

        System.assert(FObject.processIsValid(), 'Found errors');
    }

    // Demonstrates: inserting and updating accounts
    @IsTest
    public static void testInsertUpdateAccounts() {
        FObject.setGlobalVerbose('debug');
        FObject.setGlobalVariable('amount', 5000000);

        // GIVEN we insert accounts with any Industry except Energy	and Chemicals
        Map<String, FObject> template = ForceeaTrainingDataFactory.templateMajorAccounts();
        template.get(ForceeaTrainingDataFactory.ACCOUNTS)
            .setNumberOfRecords(100)
            .setDefinition(Account.Industry, 'random type(picklist) except(Energy,Chemicals)');
        FObject.insertRecordsFromTemplate(template, true);

        // WHEN we update the AnnualRevenue to 5M
        template.get(ForceeaTrainingDataFactory.ACCOUNTS)
            .setDefinitionForUpdate(Account.AnnualRevenue, 'static value({@amount})')
            .updateFields()
            .updateRecords(true);

        // THEN the accounts are updated successfully
        Integer errors = 0;
        for (Account accountRecord : [SELECT AnnualRevenue FROM Account]) {
            if (accountRecord.AnnualRevenue != 5000000) {
                errors++;
            }
        }
        if (!FObject.processIsValid()) {
            errors++;
        }
        System.assert(errors == 0, 'The accounts were not updated correctly');
    }

    // Demonstrates: inserting and updating opportunities
    @IsTest
    public static void testInsertUpdateOpportunities() {
        FObject.setGlobalVerbose('debug');

        // GIVEN we insert accounts with any Industry except Energy	and Chemicals
        Map<String, FObject> template = ForceeaTrainingDataFactory.templateBigOpportunitiesWithMajorAccounts();

        template.get(ForceeaTrainingDataFactory.ACCOUNTS)
            .setNumberOfRecords(10)
            .setDefinition(Account.Industry, 'random type(picklist) except(Energy,Chemicals)');
        template.get(ForceeaTrainingDataFactory.OPPORTUNITIES)
            .setNumberOfRecords(100);
        FObject.insertRecordsFromTemplate(template, true);

        // WHEN we close the opportunities
        template.get(ForceeaTrainingDataFactory.OPPORTUNITIES)
            .setDefinitionForUpdate(Opportunity.StageName, 'static value(Closed Won)')
            .updateFields()
            .updateRecords(true);

        // THEN there are no open opportunities
        Integer errors = 0;
        for (Opportunity oppRecord : [SELECT IsClosed FROM Opportunity]) {
            if (oppRecord.IsClosed == false) {
                errors += 1;
                break;
            }
        }
        if (!FObject.processIsValid()) {
            errors += 2;
        }
        System.assertEquals(0, errors, 'The opportunities were not closed');
    }

}
