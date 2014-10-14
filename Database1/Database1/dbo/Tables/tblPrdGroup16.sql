CREATE TABLE [dbo].[tblPrdGroup16] (
    [prdGroup16ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NULL,
    [p16PrdGroup16ClientCode] NVARCHAR (100) NULL,
    [p16PrdGroup16Desc]       NVARCHAR (100) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [tblPrdGroup16_pk] PRIMARY KEY CLUSTERED ([prdGroup16ID] ASC)
);

