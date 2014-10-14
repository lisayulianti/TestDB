CREATE TABLE [dbo].[tblPromotionBudgetOverview] (
    [promotionBudgetOverviewId] INT           IDENTITY (1, 1) NOT NULL,
    [promotionID]               INT           NOT NULL,
    [tblName]                   VARCHAR (50)  NULL,
    [rowCode]                   VARCHAR (100) NULL,
    [rowAmount]                 FLOAT (53)    NULL,
    [rowMonth]                  INT           NULL,
    [budgetPivot]               VARCHAR (50)  NULL,
    [roleID]                    INT           NULL,
    CONSTRAINT [PK_tblPromotionBudgetOverview] PRIMARY KEY CLUSTERED ([promotionBudgetOverviewId] ASC),
    CONSTRAINT [FK_tblPromotionBudgetOverview_tblPromotion] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[tblPromotion] ([promotionID]),
    CONSTRAINT [FK_tblPromotionBudgetOverview_tblRole] FOREIGN KEY ([roleID]) REFERENCES [dbo].[tblRole] ([roleID])
);

