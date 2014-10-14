CREATE TABLE [dbo].[tblPrdGroup5] (
    [prdGroup5ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NULL,
    [p05PrdGroup5ClientCode] NVARCHAR (100) NULL,
    [p05PrdGroup5Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NULL,
    CONSTRAINT [tblPrdGroup5_pk] PRIMARY KEY CLUSTERED ([prdGroup5ID] ASC)
);

