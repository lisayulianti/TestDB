CREATE TABLE [dbo].[tblPromotionExclusionProduct] (
    [PromotionExclGoodsID] INT IDENTITY (1, 1) NOT NULL,
    [countryID]            INT NOT NULL,
    [promotionID]          INT NOT NULL,
    [productID]            INT NOT NULL,
    [exclfreeProductID]    INT NOT NULL,
    CONSTRAINT [PK_tblPromotionExclusionProduct] PRIMARY KEY CLUSTERED ([PromotionExclGoodsID] ASC)
);

