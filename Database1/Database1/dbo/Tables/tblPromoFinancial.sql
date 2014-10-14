CREATE TABLE [dbo].[tblPromoFinancial] (
    [promoFinancialID]            INT           IDENTITY (1, 1) NOT NULL,
    [promotionID]                 INT           NULL,
    [countryID]                   INT           NULL,
    [finPromotionTypeID]          INT           NULL,
    [finCostTypeID]               INT           NULL,
    [pnlID]                       INT           NULL,
    [finConditionType]            NVARCHAR (4)  NULL,
    [finGeneralLedgerCode]        INT           NULL,
    [finGeneralLedgerCodeDesc]    NVARCHAR (50) NULL,
    [finGeneralLedgerCodeBSh]     INT           NULL,
    [finGeneralLedgerCodeBShDesc] NVARCHAR (50) NULL,
    [finSpendType]                NVARCHAR (50) NULL,
    [finAmount]                   FLOAT (53)    NULL,
    [finBuildingBLockID]          INT           NULL,
    CONSTRAINT [tblPromoFinancial_pk] PRIMARY KEY CLUSTERED ([promoFinancialID] ASC)
);

