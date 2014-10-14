CREATE TABLE [dbo].[tblCusGroup8] (
    [cusGroup8ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [c08CusGroup8ClientCode] NVARCHAR (100) NULL,
    [c08CusGroup8Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [tblCusGroup8_pk] PRIMARY KEY CLUSTERED ([cusGroup8ID] ASC)
);

