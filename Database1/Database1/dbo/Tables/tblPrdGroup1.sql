CREATE TABLE [dbo].[tblPrdGroup1] (
    [prdGroup1ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NULL,
    [p01PrdGroup1ClientCode] NVARCHAR (100) NULL,
    [p01PrdGroup1Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NULL,
    CONSTRAINT [tblPrdGroup1_pk] PRIMARY KEY CLUSTERED ([prdGroup1ID] ASC)
);

