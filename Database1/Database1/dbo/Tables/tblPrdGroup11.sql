CREATE TABLE [dbo].[tblPrdGroup11] (
    [prdGroup11ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NULL,
    [p11PrdGroup11ClientCode] NVARCHAR (100) NULL,
    [p11PrdGroup11Desc]       NVARCHAR (100) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [tblPrdGroup11_pk] PRIMARY KEY CLUSTERED ([prdGroup11ID] ASC)
);

