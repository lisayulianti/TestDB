CREATE TABLE [dbo].[tblPrdGroup4] (
    [prdGroup4ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NULL,
    [p04PrdGroup4ClientCode] NVARCHAR (100) NULL,
    [p04PrdGroup4Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NULL,
    CONSTRAINT [tblPrdGroup4_pk] PRIMARY KEY CLUSTERED ([prdGroup4ID] ASC)
);

