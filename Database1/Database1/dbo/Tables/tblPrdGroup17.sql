CREATE TABLE [dbo].[tblPrdGroup17] (
    [prdGroup17ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NULL,
    [p17PrdGroup17ClientCode] NVARCHAR (100) NULL,
    [p17PrdGroup17Desc]       NVARCHAR (100) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [tblPrdGroup17_pk] PRIMARY KEY CLUSTERED ([prdGroup17ID] ASC)
);

