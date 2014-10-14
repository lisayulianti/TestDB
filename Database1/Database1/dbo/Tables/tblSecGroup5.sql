CREATE TABLE [dbo].[tblSecGroup5] (
    [secGroup5ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [s05SecGroup5ClientCode] NVARCHAR (100) NULL,
    [s05SecGroup5Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [PK_tblSecGroup5] PRIMARY KEY CLUSTERED ([secGroup5ID] ASC)
);

