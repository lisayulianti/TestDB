CREATE TABLE [dbo].[tblCusGroup1] (
    [cusGroup1ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [c01CusGroup1ClientCode] NVARCHAR (100) NULL,
    [c01CusGroup1Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [tblCusGroup1_pk] PRIMARY KEY CLUSTERED ([cusGroup1ID] ASC)
);

