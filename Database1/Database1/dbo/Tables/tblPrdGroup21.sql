CREATE TABLE [dbo].[tblPrdGroup21] (
    [prdGroup21ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NULL,
    [p21PrdGroup21ClientCode] NVARCHAR (100) NULL,
    [p21PrdGroup21Desc]       NVARCHAR (100) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [tblPrdGroup21_pk] PRIMARY KEY CLUSTERED ([prdGroup21ID] ASC)
);

