CREATE TABLE [dbo].[tblPrdGroup2] (
    [prdGroup2ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NULL,
    [p02PrdGroup2ClientCode] NVARCHAR (100) NULL,
    [p02PrdGroup2Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NULL,
    CONSTRAINT [tblPrdGroup2_pk] PRIMARY KEY CLUSTERED ([prdGroup2ID] ASC)
);

