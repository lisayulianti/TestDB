CREATE TABLE [dbo].[tblPromotionDetailsBuildingBlock] (
    [BuildingBlockID] INT            IDENTITY (1, 1) NOT NULL,
    [countryID]       INT            NOT NULL,
    [bblBlockName]    NVARCHAR (100) NOT NULL,
    [bblPageName]     NVARCHAR (30)  NOT NULL,
    [importLogID]     INT            NULL,
    CONSTRAINT [PK_tblPromotionDetailsBuildingBlock] PRIMARY KEY CLUSTERED ([BuildingBlockID] ASC)
);

