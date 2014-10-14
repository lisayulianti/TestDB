CREATE TABLE [dbo].[tblPrdGroup19] (
    [prdGroup19ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NULL,
    [p19PrdGroup19ClientCode] NVARCHAR (100) NULL,
    [p19PrdGroup19Desc]       NVARCHAR (100) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [tblPrdGroup19_pk] PRIMARY KEY CLUSTERED ([prdGroup19ID] ASC)
);

