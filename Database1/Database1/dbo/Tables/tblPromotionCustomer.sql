CREATE TABLE [dbo].[tblPromotionCustomer] (
    [promotionId] INT NOT NULL,
    [customerId]  INT NOT NULL,
    CONSTRAINT [FK_tblPromotionCustomer_tblPromotion] FOREIGN KEY ([promotionId]) REFERENCES [dbo].[tblPromotion] ([promotionID])
);

