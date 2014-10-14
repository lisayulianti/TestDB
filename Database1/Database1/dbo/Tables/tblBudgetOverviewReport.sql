CREATE TABLE [dbo].[tblBudgetOverviewReport] (
    [budgetOverviewReportID] INT            IDENTITY (1, 1) NOT NULL,
    [reportID]               INT            NULL,
    [sqlSP]                  NVARCHAR (500) NULL,
    [countryID]              INT            NULL,
    [importLogID]            INT            NULL,
    CONSTRAINT [PK_tblBudgetOverviewReport] PRIMARY KEY CLUSTERED ([budgetOverviewReportID] ASC),
    CONSTRAINT [FK_tblBudgetOverviewReport_tblCountry] FOREIGN KEY ([countryID]) REFERENCES [dbo].[tblCountry] ([countryID]),
    CONSTRAINT [FK_tblBudgetOverviewReport_tblReportSettings] FOREIGN KEY ([reportID]) REFERENCES [dbo].[tblReportSettings] ([reportID])
);

