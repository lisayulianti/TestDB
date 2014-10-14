CREATE TABLE [dbo].[tblCusGroup5] (
    [cusGroup5ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [c05CusGroup5ClientCode] NVARCHAR (100) NULL,
    [c05CusGroup5Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [tblCusGroup5_pk] PRIMARY KEY CLUSTERED ([cusGroup5ID] ASC)
);

