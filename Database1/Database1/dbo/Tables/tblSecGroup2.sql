CREATE TABLE [dbo].[tblSecGroup2] (
    [secGroup2ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [s02SecGroup2ClientCode] NVARCHAR (100) NULL,
    [s02SecGroup2Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [PK_tblSecGroup2] PRIMARY KEY CLUSTERED ([secGroup2ID] ASC)
);

