CREATE TABLE [dbo].[tblCusGroup4] (
    [cusGroup4ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [c04CusGroup4ClientCode] NVARCHAR (100) NULL,
    [c04CusGroup4Desc]       NVARCHAR (100) NULL,
    [importLogID]            INT            NOT NULL,
    CONSTRAINT [tblCusGroup4_pk] PRIMARY KEY CLUSTERED ([cusGroup4ID] ASC)
);

