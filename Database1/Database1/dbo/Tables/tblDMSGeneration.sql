CREATE TABLE [dbo].[tblDMSGeneration] (
    [DMSGenerationID]   INT            IDENTITY (1, 1) NOT NULL,
    [countryID]         INT            NOT NULL,
    [promotionID]       INT            NULL,
    [dgfileName]        NVARCHAR (100) NULL,
    [dgDMSgeneration]   INT            NULL,
    [dgDMScreationDate] DATETIME       NULL,
    [dgCreator]         NVARCHAR (50)  NULL,
    [customerID]        INT            NULL,
    CONSTRAINT [tblDMSGeneration_pk] PRIMARY KEY CLUSTERED ([DMSGenerationID] ASC)
);

