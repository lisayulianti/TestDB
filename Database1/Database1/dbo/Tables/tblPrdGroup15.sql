CREATE TABLE [dbo].[tblPrdGroup15] (
    [prdGroup15ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NULL,
    [p15PrdGroup15ClientCode] NVARCHAR (100) NULL,
    [p15PrdGroup15Desc]       NVARCHAR (100) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [tblPrdGroup15_pk] PRIMARY KEY CLUSTERED ([prdGroup15ID] ASC)
);

