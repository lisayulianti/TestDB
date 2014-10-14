CREATE TABLE [dbo].[tblCusGroup6] (
    [cusGroup6ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [c06CusGroup6ClientCode] NVARCHAR (100) NULL,
    [c06CusGroup6Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [tblCusGroup6_pk] PRIMARY KEY CLUSTERED ([cusGroup6ID] ASC)
);

