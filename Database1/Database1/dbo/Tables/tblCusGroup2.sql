CREATE TABLE [dbo].[tblCusGroup2] (
    [cusGroup2ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [c02CusGroup2ClientCode] NVARCHAR (100) NULL,
    [c02CusGroup2Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [tblCusGroup2_pk] PRIMARY KEY CLUSTERED ([cusGroup2ID] ASC)
);

