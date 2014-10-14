CREATE TABLE [dbo].[tblReportSettings] (
    [reportID]     INT            IDENTITY (1, 1) NOT NULL,
    [countryID]    INT            NULL,
    [description]  NVARCHAR (100) NULL,
    [roleID]       INT            NULL,
    [departmentID] INT            NULL,
    [userID]       INT            NULL,
    [reportType]   NVARCHAR (50)  NULL,
    [importLogID]  INT            NULL,
    CONSTRAINT [PK_tblReportSettings] PRIMARY KEY CLUSTERED ([reportID] ASC),
    CONSTRAINT [FK_tblReportSettings_tblCountry] FOREIGN KEY ([countryID]) REFERENCES [dbo].[tblCountry] ([countryID]),
    CONSTRAINT [FK_tblReportSettings_tblDepartment] FOREIGN KEY ([departmentID]) REFERENCES [dbo].[tblDepartment] ([departmentID]),
    CONSTRAINT [FK_tblReportSettings_tblUser] FOREIGN KEY ([userID]) REFERENCES [dbo].[tblUser] ([userID])
);

