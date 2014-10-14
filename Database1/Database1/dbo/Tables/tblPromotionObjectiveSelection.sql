CREATE TABLE [dbo].[tblPromotionObjectiveSelection] (
    [proObjectiveID]   INT           IDENTITY (1, 1) NOT NULL,
    [countryID]        INT           NULL,
    [proObjectiveDesc] NVARCHAR (50) NULL,
    [proObjectiveType] NVARCHAR (15) CONSTRAINT [DF_tblPromotionObjectiveSelection_proObjectiveType] DEFAULT (N'F') NULL,
    [importLogID]      INT           NULL,
    CONSTRAINT [tblPromotionObjectiveSelection_pk] PRIMARY KEY CLUSTERED ([proObjectiveID] ASC)
);

