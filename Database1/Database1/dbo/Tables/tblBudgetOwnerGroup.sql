CREATE TABLE [dbo].[tblBudgetOwnerGroup] (
    [budgetOwnerGroupID]   INT           IDENTITY (1, 1) NOT NULL,
    [countryID]            INT           NOT NULL,
    [budgetOwnerGroupName] VARCHAR (100) NULL,
    [importLogID]          INT           NULL,
    CONSTRAINT [PK_tblBudgetOwnerGroup_1] PRIMARY KEY CLUSTERED ([budgetOwnerGroupID] ASC),
    CONSTRAINT [FK_tblBudgetOwnerGroup_tblCountry] FOREIGN KEY ([countryID]) REFERENCES [dbo].[tblCountry] ([countryID])
);

