CREATE TABLE [dbo].[tblImportOutput] (
    [ImportOutputID]      INT             IDENTITY (1, 1) NOT NULL,
    [countryID]           INT             NULL,
    [imsTemplateFilePath] NVARCHAR (2000) NULL,
    [imsTemplateFileName] NVARCHAR (100)  NULL,
    [imsTemplateSheet]    NVARCHAR (100)  NULL,
    [imsDataQuery]        NVARCHAR (1000) NULL,
    [importLogID]         INT             NULL,
    CONSTRAINT [tblImportOutput_pk] PRIMARY KEY CLUSTERED ([ImportOutputID] ASC)
);

