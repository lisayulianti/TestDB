CREATE TABLE [dbo].[tblCustomerHierarchy] (
    [customerHierarchyID] INT IDENTITY (1, 1) NOT NULL,
    [countryID]           INT NOT NULL,
    [cusGroup1ID]         INT NULL,
    [cusGroup2ID]         INT NULL,
    [cusGroup3ID]         INT NULL,
    [cusGroup4ID]         INT NULL,
    [cusGroup5ID]         INT NULL,
    [cusGroup6ID]         INT NULL,
    [cusGroup7ID]         INT NULL,
    [cusGroup8ID]         INT NULL,
    [customerID]          INT NULL,
    [secGroup1ID]         INT NULL,
    [secGroup2ID]         INT NULL,
    [secGroup3ID]         INT NULL,
    [secGroup4ID]         INT NULL,
    [secGroup5ID]         INT NULL,
    CONSTRAINT [tblCustomerHierarchy_pk] PRIMARY KEY CLUSTERED ([customerHierarchyID] ASC)
);

