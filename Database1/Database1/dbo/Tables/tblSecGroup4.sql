CREATE TABLE [dbo].[tblSecGroup4] (
    [secGroup4ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [s04SecGroup4ClientCode] NVARCHAR (100) NULL,
    [s04SecGroup4Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [PK_tblSecGroup4] PRIMARY KEY CLUSTERED ([secGroup4ID] ASC)
);

