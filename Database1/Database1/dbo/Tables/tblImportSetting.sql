CREATE TABLE [dbo].[tblImportSetting] (
    [importSettingID]    INT             IDENTITY (1, 1) NOT NULL,
    [countryID]          INT             NULL,
    [imsSourceFilePath]  NVARCHAR (2000) NULL,
    [imsArchiveFilePath] NVARCHAR (2000) NULL,
    [imsAutoRefresh]     BIT             NULL,
    [imsInterval]        VARCHAR (50)    NULL,
    [imsEmailTime]       VARCHAR (50)    NULL,
    [imsSchName]         VARCHAR (50)    NULL,
    [importLogID]        INT             NULL,
    CONSTRAINT [tblImportSetting_pk] PRIMARY KEY CLUSTERED ([importSettingID] ASC)
);

