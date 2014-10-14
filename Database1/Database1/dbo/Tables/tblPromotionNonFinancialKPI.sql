CREATE TABLE [dbo].[tblPromotionNonFinancialKPI] (
    [promotionNonFinancialKPIID] INT            IDENTITY (1, 1) NOT NULL,
    [promotionID]                INT            NOT NULL,
    [proObjectiveID]             INT            NOT NULL,
    [valueBase]                  NVARCHAR (MAX) NULL,
    [valuePlan]                  NVARCHAR (MAX) NULL,
    [valueActual]                NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblPromotionNonFinancialKPI] PRIMARY KEY CLUSTERED ([promotionNonFinancialKPIID] ASC),
    CONSTRAINT [FK_tblPromotionNonFinancialKPI_tblPromotion] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[tblPromotion] ([promotionID]),
    CONSTRAINT [FK_tblPromotionNonFinancialKPI_tblPromotionObjectiveSelection] FOREIGN KEY ([proObjectiveID]) REFERENCES [dbo].[tblPromotionObjectiveSelection] ([proObjectiveID])
);

