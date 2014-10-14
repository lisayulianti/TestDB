CREATE TABLE [dbo].[tblPrdGroup9] (
    [prdGroup9ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NULL,
    [p09PrdGroup9ClientCode] NVARCHAR (100) NULL,
    [p09PrdGroup9Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NULL,
    CONSTRAINT [tblPrdGroup9_pk] PRIMARY KEY CLUSTERED ([prdGroup9ID] ASC)
);

