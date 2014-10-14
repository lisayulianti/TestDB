CREATE TABLE [dbo].[tblPrdGroup12] (
    [prdGroup12ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NULL,
    [p12PrdGroup12ClientCode] NVARCHAR (100) NULL,
    [p12PrdGroup12Desc]       NVARCHAR (100) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [tblPrdGroup12_pk] PRIMARY KEY CLUSTERED ([prdGroup12ID] ASC)
);

