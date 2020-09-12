public with sharing class ForceeaTrainingDataFactory {

    public static final String ACCOUNTS = 'Accounts';
    public static final String CASES = 'Cases';
    public static final String CONTACTS = 'Contacts';
    public static final String LEADS = 'Leads';
    public static final String OPPORTUNITIES = 'Opportunities';

    private static final Integer DEFAULT_NUM_ACCOUNTS = 10;
    private static final Integer DEFAULT_NUM_CASES = 10;
    private static final Integer DEFAULT_NUM_CONTACTS = 50;
    private static final Integer DEFAULT_NUM_OPPORTUNITIES = 100;

    public static Map<String, FObject> templateAccounts() {
        return new Map<String, FObject>{
            ACCOUNTS => new FObject(Account.SObjectType, DEFAULT_NUM_ACCOUNTS)
                .setDefinition(Account.Name, 'static value("Company ")')
                .setDefinition(Account.Name, 'serial type(number) from(100) step(1) scale(0)')
        };
    }

    public static Map<String, FObject> templateStandardAccounts() {
        Map<String, FObject> results = new Map<String, FObject>(templateAccounts());

        results.get(ACCOUNTS)
            .setDefinition(Account.RecordTypeId, 'static value(StandardAccount)')
            .setDefinition(Account.AnnualRevenue, 'random type(number) from(100000) to(1000000) scale(2)');

        return results;
    }

    public static Map<String, FObject> templateMajorAccounts() {
        Map<String, FObject> results = new Map<String, FObject>(templateAccounts());

        results.get(ACCOUNTS)
            .setDefinition(Account.RecordTypeId, 'static value(MajorAccount)')
            .setDefinition(Account.AnnualRevenue, 'random type(number) from(1000000) to(100000000) scale(2)');

        return results;
    }

    public static Map<String, FObject> templateAttachments() {
        return new Map<String, FObject>{
            'Attachments' => new FObject(Attachment.SObjectType, 100)
                .setDefinition(Attachment.Name, 'static value(Attachment)')
                .setDefinition(Attachment.Name, 'serial type(number) from(1) step(1) scale(0)')
                .setDefinition(Attachment.Body, 'random type(text) minLength(30) maxLength(100)')
        };
    }

    public static Map<String, FObject> templateAttachmentsWithEmails() {
        Map<String, FObject> results = new Map<String, FObject>(templateAttachments());

        results.get('Attachments')
            .setDefinition(Attachment.ParentId, 'random lookup(EmailMessage) source(forceea)');

        return results;
    }

    public static Map<String, FObject> templateCases() {
        return new Map<String, FObject>{
            CASES => new FObject(Case.SObjectType, DEFAULT_NUM_CASES)
                .setDefinition(Case.AccountId, 'random lookup(Account) source(salesforce)')
                .setDefinition(Case.ContactId, 'random lookup(Contact) source(salesforce)')
                .setDefinition(Case.Origin, 'random type(picklist)')
                .setDefinition(Case.Type, 'random type(picklist)')
                .setDefinition(Case.Status, 'static value(Working)')
                .setDefinition(Case.Subject, 'random type(text) minLength(50) maxLength(200)')
                .setDefinition(Case.Reason, 'random type(picklist)')
                .setDefinition(Case.Description, 'random type(text) minLength(50) maxLength(200)')
        };
    }

    public static Map<String, FObject> templateContacts() {
        return new Map<String, FObject>{
            CONTACTS => new FObject(Contact.SObjectType, DEFAULT_NUM_CONTACTS)
                .setDefinition(Contact.FirstName, 'random type(firstName) group(mailing)')
                .setDefinition(Contact.LastName, 'random type(lastName) group(mailing)')
                .setDefinition(Contact.Email, 'random type(email)')
                .setDefinition(Contact.MailingStreet, 'random type(street) group(mailing)')
                .setDefinition(Contact.MailingPostalCode, 'random type(postalCode) group(mailing)')
                .setDefinition(Contact.MailingCity, 'random type(city) group(mailing)')
                .setDefinition(Contact.MailingState, 'random type(state) group(mailing)')
                .setDefinition(Contact.MailingCountry, 'random type(country) group(mailing)')
        };
    }

    public static Map<String, FObject> templateContactsWithMajorAccounts() {
        Map<String, FObject> results = new Map<String, FObject>();
        results.putAll(templateMajorAccounts());
        results.putAll(templateContacts());

        results.get(CONTACTS)
            .setDefinition(Contact.AccountId, 'serial lookup(Account) mode(cyclical) source(forceea)');
        return results;
    }

    public static Map<String, FObject> templateEmailMessages() {
        return new Map<String, FObject>{
            'EmailMessages' => new FObject(EmailMessage.SObjectType, 100)
                .setDefinition(EmailMessage.Subject, 'static value(Email)')
                .setDefinition(EmailMessage.Subject, 'serial type(number) from(1) step(1) scale(0)')
                .setDefinition(EmailMessage.TextBody, 'copy field(Subject)')
                .setDefinition(EmailMessage.Incoming, 'static value(true)')
                .setDefinition(EmailMessage.Status, 'static value(0)')
                .setDefinition(EmailMessage.ParentId, 'random lookup(Case) source(salesforce)')
        };
    }

    public static Map<String, FObject> templateEvents() {
        return new Map<String, FObject>{
            'Events' => new FObject(Event.SObjectType, 100)
                .setDefinition(Event.Subject, 'random type(picklist)')
                .setDefinition(Event.Type, 'random type(picklist)')
                .setDefinition(Event.WhoId, 'random lookup(Contact) source(salesforce)')
                .setDefinition(Event.ActivityDatetime, 'random type(datetime) from(2018-1-1) to(2018-12-31)')
                .setDefinition(Event.DurationInMinutes, 'random type(number) from(1) to(10) scale(0)')
        };
    }

    public static Map<String, FObject> templateFObjectOnes() {
        return new Map<String, FObject>{
            'FObjectOnes' => new FObject(FObjectOne__c.SObjectType, 100)
                .setDefinition(FObjectOne__c.TestCheckbox__c, 'static value(true)')
                .setDefinition(FObjectOne__c.TestCurrency__c, 'random type(number) from(1) to(100) scale(0)')
                .setDefinition(FObjectOne__c.TestDate__c, 'random type(date) from(2017-1-1) to(2017-12-31)')
                .setDefinition(FObjectOne__c.TestDatetime__c, 'random type(datetime) from(2017-1-1) to(2017-12-31)')
                .setDefinition(FObjectOne__c.TestDecimal__c, 'random type(number) from(1) to(100) scale(3)')
                .setDefinition(FObjectOne__c.TestEmail__c, 'random type(email)')
                .setDefinition(FObjectOne__c.TestInteger__c, 'random type(number) from(1) to(100) scale(0)')
                .setDefinition(FObjectOne__c.TestLookup__c, 'random lookup(FObjectTwo__c) source(forceea)')
                .setDefinition(FObjectOne__c.TestMultiPicklistA__c, 'random type(picklist)')
                .setDefinition(FObjectOne__c.TestPercent__c, 'random type(number) from(1) to(100) scale(1)')
                .setDefinition(FObjectOne__c.TestPhone__c, 'static value(2102525125)')
                .setDefinition(FObjectOne__c.TestPicklistA__c, 'random type(picklist) except(a0)')
                .setDefinition(FObjectOne__c.TestPicklistB__c, 'random type(picklist)')
                .setDefinition(FObjectOne__c.TestPicklistC__c, 'random type(picklist)')
                .setDefinition(FObjectOne__c.TestPicklistD__c, 'random type(picklist) except (d0,d1)')
                .setDefinition(FObjectOne__c.TestText__c,
                    'random type(string) minLength(10) maxLength(30) startWith(lower) include(lower,upper,digit)')
                .setDefinition(FObjectOne__c.TestTextArea__c,
                    'random type(string) minLength(10) maxLength(30) startWith(lower) include(lower,upper,digit)')
                .setDefinition(FObjectOne__c.TestTextAreaLong__c,
                    'random type(string) minLength(50) maxLength(200) startWith(lower) include(lower,upper,digit)')
                .setDefinition(FObjectOne__c.TestTextAreaRich__c,
                    'random type(string) minLength(50) maxLength(200) startWith(lower) include(lower,upper,digit)')
                .setDefinition(FObjectOne__c.TestTextRequired__c,
                    'random type(string) minLength(10) maxLength(20) startWith(upper) include(lower,upper)')
                .setDefinition(FObjectOne__c.TestTime__c, 'static value(22:10:05)')
                .setDefinition(FObjectOne__c.TestUrl__c, 'random type(url)')
        };
    }

    public static Map<String, FObject> templateLeads() {
        return new Map<String, FObject>{
            LEADS => new FObject(Lead.SObjectType, 100)
                .setDefinition(Lead.FirstName, 'random type(firstname) group(name)')
                .setDefinition(Lead.LastName, 'random type(lastname) group(name)')
                .setDefinition(Lead.Email, 'random type(email)')
                .setDefinition(Lead.Title, 'random type(list) value(Developer, CFO, Account Manager, CEO, Logistics Manager)')
                .setDefinition(Lead.Company, 'static value("Company ")')
                .setDefinition(Lead.Company, 'serial type(number) from(100) step(1) scale(0)')
                .setDefinition(Lead.AnnualRevenue, 'random type(number) from(1000000) to(10000000) scale(-3)')
                .setDefinition(Lead.NumberOfEmployees, 'random type(list) value(10,20,30)')
                .setDefinition(Lead.Industry, 'random type(picklist)')
                .setDefinition(Lead.Status, 'static value(Open)')
                .setDefinition(Lead.Street, 'random type(street) group(other)')
                .setDefinition(Lead.PostalCode, 'random type(postalCode) group(other)')
                .setDefinition(Lead.City, 'random type(city) group(other)')
                .setDefinition(Lead.State, 'random type(state) group(other)')
                .setDefinition(Lead.Country, 'random type(country) group(other)')
        };
    }

    public static Map<String, FObject> templateOpportunities() {
        return new Map<String, FObject>{
            OPPORTUNITIES => new FObject(Opportunity.SObjectType, DEFAULT_NUM_OPPORTUNITIES)
                .setDefinition(Opportunity.Name, 'static value(Opportunity-)')
                .setDefinition(Opportunity.Name, 'serial type(number) from(1) step(1) scale(0)')
                .setDefinition(Opportunity.Amount, 'random type(number) from(10000) to(100000) scale(2)')
                .setDefinition(Opportunity.CloseDate, 'random type(date) from(2020-01-01) to(2020-12-31)')
                .setDefinition(Opportunity.StageName, 'static value(Prospecting)')
                .setDefinition(Opportunity.Type, 'random type(picklist)')
        };
    }

    public static Map<String, FObject> templateBigOpportunities() {
        Map<String, FObject> results = new Map<String, FObject>(templateOpportunities());

        results.get(OPPORTUNITIES)
            .setDefinition(Opportunity.RecordTypeId, 'static value(BigOpp)');

        return results;
    }

    public static Map<String, FObject> templateBigOpportunitiesWithMajorAccounts() {
        Map<String, FObject> results = new Map<String, FObject>();
        results.putAll(templateMajorAccounts());
        results.putAll(templateBigOpportunities());

        results.get(OPPORTUNITIES)
            .setDefinition(Opportunity.AccountId, 'serial lookup(Account) mode(cyclical) source(forceea)');
        return results;
    }

    public static Map<String, FObject> templateFeedItems() {
        return new Map<String, FObject>{
            'FeedItem' => new FObject(FeedItem.SObjectType, 100)
                .setDefinition(FeedItem.Body, 'random type(text) minLength(50) maxLength(500)')
                .setDefinition(FeedItem.ParentId, 'random lookup(Contact) source(forceea)')
                .setDefinition(FeedItem.Status, 'static value(Published)')
                .setDefinition(FeedItem.Type, 'static value(TextPost)')
                .setDefinition(FeedItem.Title, 'random type(text) minLength(50) maxLength(250)')
        };
    }

    public static void templatePriceBooksAndProducts() {
        FObject objPricebook = new FObject(Pricebook2.SObjectType, 1)
            .setDefinition(Pricebook2.Name, 'static value(MyPriceBook)')
            .setDefinition(Pricebook2.IsActive, 'static value(true)');

        FObject objProduct = new FObject(Product2.SObjectType, 10)
            .setDefinition(Product2.Name, 'static value(Product-)')
            .setDefinition(Product2.Name, 'serial type(number) from(1) step(1) scale(0)')
            .setDefinition(Product2.Description, 'random type(text) minLength(25) maxLength(50)')
            .setDefinition(Product2.IsActive, 'static value(true)')
            .setDefinition('$StandardPrice', 'random type(number) from(1000) to(2000) scale(2)')
            .setStandardPricebookEntries('$StandardPrice');

        FObject objPricebookEntry = new FObject(PricebookEntry.SObjectType, 10)
            .setDefinition(PricebookEntry.IsActive, 'static value(true)')
            .setDefinition(PricebookEntry.Pricebook2Id,
                'static lookup(PriceBook2) field(Name) value(MyPriceBook) source(forceea)')
            .setDefinition(PricebookEntry.Product2Id, 'serial lookup(Product2) mode(cyclical) source(forceea)')
            .setDefinition(PricebookEntry.UnitPrice, 'random type(number) from(100) to(200) scale(2)')
            .setDefinition(PricebookEntry.UseStandardPrice, 'static value(false)');
    }

    public static Map<String, FObject> templateTasks() {
        return new Map<String, FObject>{
            'Tasks' => new FObject(Task.SObjectType, 100)
                .setDefinition(Task.Subject, 'random type(picklist)')
                .setDefinition(Task.Priority, 'random type(picklist)')
                .setDefinition(Task.Status, 'random type(picklist)')
                .setDefinition(Task.Type, 'random type(picklist)')
                .setDefinition(Task.WhatId, 'random lookup(Account) source(salesforce)')
                .setDefinition(Task.ActivityDate, 'random type(date) from(2018-10-1) to(2018-12-31)')
        };
    }

    public static Map<String, FObject> templateUsers() {
        return new Map<String, FObject>{
            'Users' => new FObject(User.SObjectType, 1)
                .setRequiredFields(true)
                .canInsertUsers(true) // required when not testing
                .setDefinition(User.ProfileId,
                    'static lookup(Profile) field(Name) value(System Administrator) source(salesforce)')
                .setDefinition(User.UserRoleId,
                    'static lookup(UserRole) field(Name) value(CEO) source(salesforce)')
        };
    }

    public static Map<String, FObject> templateTest1() {
        Map<String, FObject> template = new Map<String, FObject>();

        template.put('FObjectTwos', new FObject(FObjectTwo__c.SObjectType, 1)
            .setDefinition(FObjectTwo__c.TestText__c, 'random type(number) from(10) to(100) scale(0)')
            .setDefinition(FObjectTwo__c.TestTextUnique__c, 'serial type(number) from(1) step(1) scale(0)')
            .setDefinition(FObjectTwo__c.TestPicklistDRequired__c, 'random type(picklist)')
        );

        template.put('Ones', new FObject(FObjectOne__c.SObjectType, 2)
            .setDefinition(FObjectOne__c.TestText__c, 'serial type(number) from(1) step(1) scale(0)')
            .setDefinition(FObjectOne__c.TestTextRequired__c, 'static value(1)')
        );

        template.put('Twos', new FObject('FObjectOne__c', 3)
            .setGroupName('Group2')
            .setDefinition(FObjectOne__c.TestText__c, 'serial type(number) from(1) step(1) scale(0)')
            .setDefinition(FObjectOne__c.TestTextRequired__c, 'static value(2)')
        );

        template.put('Threes', new FObject('FObjectOne__c', 4)
            .setDefinition(FObjectOne__c.TestText__c, 'serial type(number) from(1) step(1) scale(0)')
            .setDefinition(FObjectOne__c.TestTextRequired__c, 'static value(3)')
        );

        return template;
    }

}
