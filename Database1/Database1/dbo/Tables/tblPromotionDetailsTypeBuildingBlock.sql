CREATE TABLE [dbo].[tblPromotionDetailsTypeBuildingBlock] (
    [promotionDetailsTypeBuildingBlockSelection] INT IDENTITY (1, 1) NOT NULL,
    [promotionID]                                INT NOT NULL,
    [buildingBlockID]                            INT NOT NULL,
    CONSTRAINT [PK_tblPromotionTypeBuildingBlock] PRIMARY KEY CLUSTERED ([promotionDetailsTypeBuildingBlockSelection] ASC),
    CONSTRAINT [FK_tblPromotionDetailsTypeBuildingBlock_tblPromotionDetailsBuildingBlock] FOREIGN KEY ([buildingBlockID]) REFERENCES [dbo].[tblPromotionDetailsBuildingBlock] ([BuildingBlockID]),
    CONSTRAINT [FK_tblPromotionTypeBuildingBlock_tblPromotion] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[tblPromotion] ([promotionID])
);

