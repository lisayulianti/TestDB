CREATE TABLE [dbo].[tblPromotionProductSelection] (
    [promotionProductSelectionID] INT IDENTITY (1, 1) NOT NULL,
    [promotionID]                 INT NULL,
    [prdProductID]                INT NULL,
    CONSTRAINT [tblPromotionProductSelection_pk] PRIMARY KEY CLUSTERED ([promotionProductSelectionID] ASC)
);

