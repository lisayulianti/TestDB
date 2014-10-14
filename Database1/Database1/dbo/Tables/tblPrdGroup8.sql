CREATE TABLE [dbo].[tblPrdGroup8] (
    [prdGroup8ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NULL,
    [p08PrdGroup8ClientCode] NVARCHAR (100) NULL,
    [p08PrdGroup8Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NULL,
    CONSTRAINT [tblPrdGroup8_pk] PRIMARY KEY CLUSTERED ([prdGroup8ID] ASC)
);

