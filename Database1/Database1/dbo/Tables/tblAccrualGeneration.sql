CREATE TABLE [dbo].[tblAccrualGeneration] (
    [JournalGenerationID]   INT            IDENTITY (1, 1) NOT NULL,
    [jgHeader]              NVARCHAR (50)  NULL,
    [countryID]             INT            NOT NULL,
    [promotionID]           INT            NULL,
    [customerID]            INT            NULL,
    [jgGeneralLedgerCode]   INT            NULL,
    [jgJournalgeneration]   INT            NULL,
    [jgJournalcreationDate] DATETIME       NULL,
    [jgBookmonth]           INT            NULL,
    [jgCreator]             NVARCHAR (100) NULL,
    CONSTRAINT [tblAccrualGeneration_pk] PRIMARY KEY CLUSTERED ([JournalGenerationID] ASC)
);

