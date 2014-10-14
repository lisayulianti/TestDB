CREATE TABLE [dbo].[tblPrdGroup20] (
    [prdGroup20ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NULL,
    [p20PrdGroup20ClientCode] NVARCHAR (100) NULL,
    [p20PrdGroup20Desc]       NVARCHAR (100) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [tblPrdGroup20_pk] PRIMARY KEY CLUSTERED ([prdGroup20ID] ASC)
);

