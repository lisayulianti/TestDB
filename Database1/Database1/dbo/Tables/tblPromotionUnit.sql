CREATE TABLE [dbo].[tblPromotionUnit] (
    [pruUnitID]   INT           IDENTITY (1, 1) NOT NULL,
    [countryID]   INT           NULL,
    [pruUnitDesc] NVARCHAR (30) NULL,
    [importLogID] INT           NULL,
    CONSTRAINT [tblPromotionUnit_pk] PRIMARY KEY CLUSTERED ([pruUnitID] ASC)
);

