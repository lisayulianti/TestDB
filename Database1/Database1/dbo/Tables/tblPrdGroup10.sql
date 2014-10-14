CREATE TABLE [dbo].[tblPrdGroup10] (
    [prdGroup10ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NULL,
    [p10PrdGroup10ClientCode] NVARCHAR (100) NULL,
    [p10PrdGroup10Desc]       NVARCHAR (100) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [tblPrdGroup10_pk] PRIMARY KEY CLUSTERED ([prdGroup10ID] ASC)
);

