CREATE TABLE [dbo].[tblSecGroup6] (
    [secGroup6ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [s06SecGroup6ClientCode] NVARCHAR (100) NULL,
    [s06SecGroup6Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [PK_tblSecGroup6] PRIMARY KEY CLUSTERED ([secGroup6ID] ASC)
);

