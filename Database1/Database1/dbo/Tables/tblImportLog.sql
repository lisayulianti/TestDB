CREATE TABLE [dbo].[tblImportLog] (
    [importLogID]              INT            IDENTITY (1, 1) NOT NULL,
    [countryID]                INT            NULL,
    [imlTargetTable]           NVARCHAR (200) NULL,
    [imlFilePeriod]            NVARCHAR (50)  NULL,
    [imlFileCode]              NVARCHAR (200) NULL,
    [imlFileName]              NVARCHAR (200) NULL,
    [imlImportDate]            DATETIME       NULL,
    [imlImportLogDescription]  NVARCHAR (200) NULL,
    [imlImportLogDescription2] NVARCHAR (200) NULL,
    [chkFileSizeKB]            INT            NULL,
    [chkEmailSent]             BIT            NULL,
    CONSTRAINT [tblImportLog_pk] PRIMARY KEY CLUSTERED ([importLogID] ASC)
);

