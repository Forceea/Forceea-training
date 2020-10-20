public with sharing class Article_WhoNeedsSoManyRecords {

    private static final String ACCOUNTS = 'Accounts';
    private static final String OPPORTUNITIES = 'Opportunities';

    public static void insertAsync() {
        FObject.setGlobalVerbose('debug');

        Map<String, FObject> template = templateOpportunitiesWithAccounts();
        template.get(ACCOUNTS)
            .setPartitionFieldName(Account.ForceeaPartition__c);
        template.get(OPPORTUNITIES)
            .setPartitionFieldName(Opportunity.ForceeaPartition__c);

        new FObjectAsync(template)
            .setNumberOfIterations(1000)
            .setNumberOfJobs(20)
            .setPartitionFieldValue('df')
            .insertRecords();
    }

    public static void deleteAsync() {
        Map<String, FObject> template = templateOpportunitiesWithAccounts();
        template.get(ACCOUNTS)
            .setPartitionFieldName(Account.ForceeaPartition__c);
        template.get(OPPORTUNITIES)
            .setPartitionFieldName(Opportunity.ForceeaPartition__c);

        new FObjectAsync(template)
            .setNumberOfJobs(20)
            .setPartitionFieldValue('df')
            .deleteRecords();
    }

    private static Map<String, FObject> templateOpportunitiesWithAccounts() {
        Map<String, FObject> template = new Map<String, FObject>();
        template.put(ACCOUNTS, new FObject(Account.SObjectType)
            .setNumberOfRecords(10)

            .setDefinition(Account.Name, 'static value(Account-)')
            .setDefinition(Account.Name, 'serial type(number) from(1) step(1) scale(0)')
            .setDefinition(Account.Industry, 'random type(picklist) except(Banking,Services)')
            .setDefinition(Account.AnnualRevenue, 'random type(number) from(1000000) to(10000000) scale(0)')
            .setDefinition(Account.Rating, 'random type(picklist)')
            .setDefinition(Account.Type, 'random type(list) value(Prospect,Customer,Analyst)')
            .setDefinition(Account.ShippingStreet, 'random type(street) group(shipping)')
            .setDefinition(Account.ShippingPostalCode, 'random type(postalCode) group(shipping)')
            .setDefinition(Account.ShippingCity, 'random type(city) group(shipping)')
            .setDefinition(Account.ShippingState, 'random type(state) group(shipping)')
            .setDefinition(Account.ShippingCountry, 'random type(country) group(shipping)')
        );

        template.put(OPPORTUNITIES, new FObject(Opportunity.SObjectType)
            .setNumberOfRecords(100)

            .setDefinition(Opportunity.AccountId, 'serial lookup(Account) mode(cyclical) source(forceea)')
            .setDefinition(Opportunity.Name, 'copy field(AccountId) from(Account.Name)')
            .setDefinition(Opportunity.Name, 'static value(" - ")')
            .setDefinition(Opportunity.Name, 'random type(text) minLength(20) maxLength(40)')

            .setDefinition(Opportunity.Amount, 'random type(number) from(10000) to(1000000) scale(2)')
            .setDefinition(Opportunity.StageName, 'random type(picklist) except(Closed Won,Closed Lost)')
            .setDefinition(Opportunity.Type, 'static value(New Business)')
            .setDefinition(Opportunity.CloseDate, 'random type(date) from(2020-01-01) to(2020-6-30)')
        );

        return template;
    }

}
