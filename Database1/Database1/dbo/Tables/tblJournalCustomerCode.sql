CREATE TABLE [dbo].[tblJournalCustomerCode] (
    [JournalCustomerCodeID]    INT           IDENTITY (1, 1) NOT NULL,
    [countryID]                INT           NOT NULL,
    [cusGroup5ID]              INT           NULL,
    [cusGroup6ID]              INT           NULL,
    [jccCusCustomerClientCode] INT           NULL,
    [jccCustomerName]          NVARCHAR (50) NULL,
    [importLogID]              INT           NULL,
    CONSTRAINT [tblJournalCustomerCode_pk] PRIMARY KEY CLUSTERED ([JournalCustomerCodeID] ASC)
);

