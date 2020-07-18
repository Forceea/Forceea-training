public with sharing class ForceeaTrainingAsync {

    public static void insertRecords() {
        FObject.setSeed(1);

        Map<String, FObject> template = new Map<String, FObject>();
        template.putAll(ForceeaTrainingDataFactory.templateContactsWithMajorAccounts());
        template.putAll(ForceeaTrainingDataFactory.templateBigOpportunitiesWithMajorAccounts());

        template.get(ForceeaTrainingDataFactory.ACCOUNTS)
            .setPartitionFieldName(Account.ForceeaPartition__c)
            .setDefinition(Account.Industry, 'random type(picklist)')
            .setDefinition(Account.Website, 'random type(url)')
            .setDefinition(Account.ShippingStreet, 'random type(street) group(shipping)')
            .setDefinition(Account.ShippingPostalCode, 'random type(postalCode) group(shipping)')
            .setDefinition(Account.ShippingCity, 'random type(city) group(shipping)')
            .setDefinition(Account.ShippingState, 'random type(state) group(shipping)')
            .setDefinition(Account.ShippingCountry, 'random type(country) group(shipping)');

        template.get(ForceeaTrainingDataFactory.CONTACTS)
            .setNumberOfRecords(30)
            .setPartitionFieldName(Contact.ForceeaPartition__c)
            .setDefinition(Contact.LeadSource, 'random type(picklist)')
            .setDefinition(Contact.Birthdate, 'random type(date) from(1950-1-1) to(1982-12-31)')
            .setDefinition(Contact.Title, 'random type(list) value(Developer, CFO, Account Manager, CEO, Logistics Manager)')
            .setDefinition(Contact.Department, 'random type(list) value(Sales, Marketing, Accounting, Management)')
            .setDefinition(Contact.Phone, 'copy field(AccountId) from(Account.Phone)')
            .setDefinition(Contact.MailingStreet, 'copy field(AccountId) from(Account.ShippingStreet)')
            .setDefinition(Contact.MailingPostalCode, 'copy field(AccountId) from(Account.ShippingPostalCode)')
            .setDefinition(Contact.MailingCity, 'copy field(AccountId) from(Account.ShippingCity)')
            .setDefinition(Contact.MailingState, 'copy field(AccountId) from(Account.ShippingState)')
            .setDefinition(Contact.MailingCountry, 'copy field(AccountId) from(Account.ShippingCountry)');

        template.get(ForceeaTrainingDataFactory.OPPORTUNITIES)
            .setNumberOfRecords(100)
            .setPartitionFieldName(Opportunity.ForceeaPartition__c);

        new FObjectAsync(template)
            .setNumberOfIterations(1000) // 30K accounts, 100K opportunities, 100K cases
            .setNumberOfJobs(25)
            .setPartitionFieldValue('df')
            .insertRecords();
    }

    public static void deleteRecords() {
        Map<String, FObject> template = new Map<String, FObject>();
        template.putAll(ForceeaTrainingDataFactory.templateContactsWithMajorAccounts());
        template.putAll(ForceeaTrainingDataFactory.templateBigOpportunitiesWithMajorAccounts());

        template.get(ForceeaTrainingDataFactory.ACCOUNTS)
            .setPartitionFieldName(Account.ForceeaPartition__c);

        template.get(ForceeaTrainingDataFactory.CONTACTS)
            .setPartitionFieldName(Contact.ForceeaPartition__c);

        template.get(ForceeaTrainingDataFactory.OPPORTUNITIES)
            .setPartitionFieldName(Opportunity.ForceeaPartition__c);

        new FObjectAsync(template)
            .setNumberOfJobs(25)
            .setPartitionFieldValue('df')
            .deleteRecords();
    }

}
