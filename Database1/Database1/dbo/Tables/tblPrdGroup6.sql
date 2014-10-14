CREATE TABLE [dbo].[tblPrdGroup6] (
    [prdGroup6ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NULL,
    [p06PrdGroup6ClientCode] NVARCHAR (100) NULL,
    [p06PrdGroup6Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NULL,
    CONSTRAINT [tblPrdGroup6_pk] PRIMARY KEY CLUSTERED ([prdGroup6ID] ASC)
);

