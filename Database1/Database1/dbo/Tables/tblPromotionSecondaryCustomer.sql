CREATE TABLE [dbo].[tblPromotionSecondaryCustomer] (
    [promotionId]         INT NOT NULL,
    [secondaryCustomerId] INT NOT NULL,
    CONSTRAINT [FK_tblPromotionSecondaryCustomer_tblPromotion] FOREIGN KEY ([promotionId]) REFERENCES [dbo].[tblPromotion] ([promotionID])
);

