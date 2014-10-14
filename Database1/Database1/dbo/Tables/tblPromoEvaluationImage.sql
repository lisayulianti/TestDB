CREATE TABLE [dbo].[tblPromoEvaluationImage] (
    [promoEvaluationImageID] INT            IDENTITY (1, 1) NOT NULL,
    [promotionID]            INT            NOT NULL,
    [prmImage]               IMAGE          NULL,
    [prmImagePath]           NVARCHAR (100) NULL,
    CONSTRAINT [PK_tblPromoEvaluationImage] PRIMARY KEY CLUSTERED ([promoEvaluationImageID] ASC),
    CONSTRAINT [FK_tblPromoEvaluationImage_tblPromotion] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[tblPromotion] ([promotionID])
);

