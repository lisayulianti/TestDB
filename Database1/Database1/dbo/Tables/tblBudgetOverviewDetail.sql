CREATE TABLE [dbo].[tblBudgetOverviewDetail] (
    [budgetOverviewDetailID] INT          IDENTITY (1, 1) NOT NULL,
    [budgetOverviewID]       INT          NOT NULL,
    [countryID]              INT          NOT NULL,
    [Year]                   INT          NOT NULL,
    [rowMonth]               INT          NOT NULL,
    [CusGroup5ID]            INT          NULL,
    [CusGroup6ID]            INT          NULL,
    [SecGroup2ID]            INT          NULL,
    [rowCode]                VARCHAR (50) NULL,
    [rowAmount]              FLOAT (53)   NULL,
    CONSTRAINT [PK_tblBudgetOverview] PRIMARY KEY CLUSTERED ([budgetOverviewDetailID] ASC),
    CONSTRAINT [FK_tblBudgetOverviewDetail_tblBudgetOverview] FOREIGN KEY ([budgetOverviewID]) REFERENCES [dbo].[tblBudgetOverview] ([budgetOverviewID]),
    CONSTRAINT [FK_tblBudgetOverviewDetail_tblCountry] FOREIGN KEY ([countryID]) REFERENCES [dbo].[tblCountry] ([countryID])
);

