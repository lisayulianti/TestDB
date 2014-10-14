CREATE TABLE [dbo].[tblBudgetOverview] (
    [budgetOverviewID] INT      IDENTITY (1, 1) NOT NULL,
    [countryID]        INT      NOT NULL,
    [createdDate]      DATE     NOT NULL,
    [startTime]        DATETIME NULL,
    [endTime]          DATETIME NULL,
    CONSTRAINT [PK_tblBudgetOverview_2] PRIMARY KEY CLUSTERED ([budgetOverviewID] ASC),
    CONSTRAINT [FK_tblBudgetOverview_tblCountry] FOREIGN KEY ([countryID]) REFERENCES [dbo].[tblCountry] ([countryID])
);

