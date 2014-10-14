CREATE TABLE [dbo].[tblPrdGroup7] (
    [prdGroup7ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NULL,
    [p07PrdGroup7ClientCode] NVARCHAR (100) NULL,
    [p07PrdGroup7Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NULL,
    CONSTRAINT [tblPrdGroup7_pk] PRIMARY KEY CLUSTERED ([prdGroup7ID] ASC)
);

