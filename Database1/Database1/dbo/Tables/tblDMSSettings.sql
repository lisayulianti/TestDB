CREATE TABLE [dbo].[tblDMSSettings] (
    [DMSSettingsID]          INT           IDENTITY (1, 1) NOT NULL,
    [countryID]              INT           NOT NULL,
    [DMSCusGroup1IDsettings] NVARCHAR (50) NULL,
    [setExtClaimDays]        INT           NULL,
    [setSpaceBuyType]        NVARCHAR (20) NULL,
    [setCLSpacebuy]          NVARCHAR (20) NULL,
    [setClpromoGT]           NVARCHAR (20) NULL,
    CONSTRAINT [tblDMSSettings_pk] PRIMARY KEY CLUSTERED ([DMSSettingsID] ASC)
);

