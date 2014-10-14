CREATE TABLE [dbo].[tblPrdGroup3] (
    [prdGroup3ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NULL,
    [p03PrdGroup3ClientCode] NVARCHAR (100) NULL,
    [p03PrdGroup3Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NULL,
    CONSTRAINT [tblPrdGroup3_pk] PRIMARY KEY CLUSTERED ([prdGroup3ID] ASC)
);

