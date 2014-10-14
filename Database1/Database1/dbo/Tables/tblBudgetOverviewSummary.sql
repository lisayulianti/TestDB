CREATE TABLE [dbo].[tblBudgetOverviewSummary] (
    [budgetOverviewSummaryID] INT           IDENTITY (1, 1) NOT NULL,
    [budgetOverviewID]        INT           NOT NULL,
    [countryID]               INT           NOT NULL,
    [rowCode]                 VARCHAR (100) NULL,
    [cusGroup5ID]             INT           NULL,
    [cusGroup6ID]             INT           NULL,
    [secGroup2ID]             INT           NULL,
    [budget]                  FLOAT (53)    NULL,
    [latestRF]                FLOAT (53)    NULL,
    CONSTRAINT [PK_tblBudgetOverview_1] PRIMARY KEY CLUSTERED ([budgetOverviewSummaryID] ASC),
    CONSTRAINT [FK_tblBudgetOverview_tblCountry1] FOREIGN KEY ([countryID]) REFERENCES [dbo].[tblCountry] ([countryID]),
    CONSTRAINT [FK_tblBudgetOverviewSummary_tblBudgetOverview] FOREIGN KEY ([budgetOverviewID]) REFERENCES [dbo].[tblBudgetOverview] ([budgetOverviewID])
);

