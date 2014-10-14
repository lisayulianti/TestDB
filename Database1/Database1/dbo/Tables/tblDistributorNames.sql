CREATE TABLE [dbo].[tblDistributorNames] (
    [DistributorNamesID]    INT           IDENTITY (1, 1) NOT NULL,
    [countryID]             INT           NULL,
    [dinCustomerClientCode] INT           NULL,
    [dinCustomerName]       NVARCHAR (50) NULL,
    [cusPrefix]             NVARCHAR (2)  NULL,
    [dinClaimnoteCode]      NVARCHAR (15) NULL,
    [dinClaimnotetwoCode]   NVARCHAR (2)  NULL,
    [importLogID]           INT           NULL,
    CONSTRAINT [tblDistributorNames_pk] PRIMARY KEY CLUSTERED ([DistributorNamesID] ASC)
);

