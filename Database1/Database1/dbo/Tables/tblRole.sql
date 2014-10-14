CREATE TABLE [dbo].[tblRole] (
    [roleID]      INT          IDENTITY (1, 1) NOT NULL,
    [countryID]   INT          NOT NULL,
    [rolRoleName] VARCHAR (50) NULL,
    [importLogID] INT          NULL,
    CONSTRAINT [tblRole_pk] PRIMARY KEY CLUSTERED ([roleID] ASC)
);

