CREATE TABLE [dbo].[tblPrdGroup14] (
    [prdGroup14ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NULL,
    [p14PrdGroup14ClientCode] NVARCHAR (100) NULL,
    [p14PrdGroup14Desc]       NVARCHAR (100) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [tblPrdGroup14_pk] PRIMARY KEY CLUSTERED ([prdGroup14ID] ASC)
);

