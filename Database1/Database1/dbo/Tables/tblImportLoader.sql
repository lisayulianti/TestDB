CREATE TABLE [dbo].[tblImportLoader] (
    [importLoaderID]    INT             IDENTITY (1, 1) NOT NULL,
    [countryID]         INT             NULL,
    [imsLoaderPath]     NVARCHAR (2000) NULL,
    [imsLoaderFilePath] NVARCHAR (2000) NULL,
    [importLogID]       INT             NULL,
    CONSTRAINT [tblImportLoader_pk] PRIMARY KEY CLUSTERED ([importLoaderID] ASC)
);

