CREATE TABLE [dbo].[tblReleaseJournalGeneration] (
    [JournalGenerationID]   INT            IDENTITY (1, 1) NOT NULL,
    [promotionID]           INT            NOT NULL,
    [customerID]            INT            NOT NULL,
    [countryID]             INT            NOT NULL,
    [rgJournalgeneration]   INT            NULL,
    [rgJournalcreationDate] DATETIME       NULL,
    [rgReleaseCreator]      NVARCHAR (100) NULL,
    CONSTRAINT [tblReleaseJournalGeneration_pk] PRIMARY KEY CLUSTERED ([JournalGenerationID] ASC)
);

