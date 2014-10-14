CREATE TABLE [dbo].[tblCusGroup7] (
    [cusGroup7ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [c07CusGroup7ClientCode] NVARCHAR (100) NULL,
    [c07CusGroup7Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [tblCusGroup7_pk] PRIMARY KEY CLUSTERED ([cusGroup7ID] ASC)
);

