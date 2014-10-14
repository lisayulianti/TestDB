CREATE TABLE [dbo].[tblPromotionActivitiesSelection] (
    [prmActivityID]          INT           IDENTITY (1, 1) NOT NULL,
    [countryID]              INT           NULL,
    [pasActivityDescription] NVARCHAR (50) NULL,
    [importLogID]            INT           NULL,
    CONSTRAINT [tblPromotionActivitiesSelection_pk] PRIMARY KEY CLUSTERED ([prmActivityID] ASC)
);

