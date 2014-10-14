CREATE TABLE [dbo].[tblPrdGroup18] (
    [prdGroup18ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NULL,
    [p18PrdGroup18ClientCode] NVARCHAR (100) NULL,
    [p18PrdGroup18Desc]       NVARCHAR (100) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [tblPrdGroup18_pk] PRIMARY KEY CLUSTERED ([prdGroup18ID] ASC)
);

