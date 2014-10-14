CREATE TABLE [dbo].[tblReportTemplate] (
    [ID]          INT           NOT NULL,
    [countryID]   INT           NULL,
    [Type]        VARCHAR (50)  NULL,
    [FileName]    VARCHAR (250) NULL,
    [reportID]    INT           NULL,
    [importLogID] INT           NULL,
    CONSTRAINT [PK_tblReportTemplate] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_tblReportTemplate_tblReportSettings] FOREIGN KEY ([reportID]) REFERENCES [dbo].[tblReportSettings] ([reportID])
);

