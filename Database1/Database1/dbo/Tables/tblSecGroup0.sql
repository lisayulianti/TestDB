CREATE TABLE [dbo].[tblSecGroup0] (
    [secondaryCustomerID] BIGINT         IDENTITY (1, 1) NOT NULL,
    [countryID]           INT            NOT NULL,
    [s00SecCusClientCode] NVARCHAR (100) NOT NULL,
    [importLogID]         INT            NOT NULL,
    CONSTRAINT [PK_tblSecGroup0] PRIMARY KEY CLUSTERED ([secondaryCustomerID] ASC)
);

