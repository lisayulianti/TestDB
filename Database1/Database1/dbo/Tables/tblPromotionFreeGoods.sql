CREATE TABLE [dbo].[tblPromotionFreeGoods] (
    [PromotionFreeGoodsID] INT IDENTITY (1, 1) NOT NULL,
    [countryID]            INT NOT NULL,
    [promotionID]          INT NOT NULL,
    [productID]            INT NOT NULL,
    [freeProductID]        INT NOT NULL,
    CONSTRAINT [tblPromotionFreeGoods_pk] PRIMARY KEY CLUSTERED ([PromotionFreeGoodsID] ASC)
);

