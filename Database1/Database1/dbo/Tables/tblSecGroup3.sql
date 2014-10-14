CREATE TABLE [dbo].[tblSecGroup3] (
    [secGroup3ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [s03SecGroup3ClientCode] NVARCHAR (100) NULL,
    [s03SecGroup3Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [PK_tblSecGroup3] PRIMARY KEY CLUSTERED ([secGroup3ID] ASC)
);

