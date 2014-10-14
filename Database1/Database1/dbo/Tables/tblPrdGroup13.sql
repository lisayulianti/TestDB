CREATE TABLE [dbo].[tblPrdGroup13] (
    [prdGroup13ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NULL,
    [p13PrdGroup13ClientCode] NVARCHAR (100) NULL,
    [p13PrdGroup13Desc]       NVARCHAR (100) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [tblPrdGroup13_pk] PRIMARY KEY CLUSTERED ([prdGroup13ID] ASC)
);

