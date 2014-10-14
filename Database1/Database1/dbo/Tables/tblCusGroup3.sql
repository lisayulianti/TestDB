CREATE TABLE [dbo].[tblCusGroup3] (
    [cusGroup3ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [c03CusGroup3ClientCode] NVARCHAR (100) NULL,
    [c03CusGroup3Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [tblCusGroup3_pk] PRIMARY KEY CLUSTERED ([cusGroup3ID] ASC)
);

