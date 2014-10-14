CREATE TABLE [dbo].[tblSecGroup1] (
    [secGroup1ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [s01SecGroup1ClientCode] NVARCHAR (100) NULL,
    [s01SecGroup1Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [PK_tblSecGroup1] PRIMARY KEY CLUSTERED ([secGroup1ID] ASC)
);

