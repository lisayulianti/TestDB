CREATE TABLE [dbo].[tblPromotionPnLMapping] (
    [PromotionPnLMappingID]       INT           IDENTITY (1, 1) NOT NULL,
    [countryID]                   INT           NOT NULL,
    [promotionTypeID]             INT           NULL,
    [promotionTypeName]           NVARCHAR (50) NULL,
    [finConditionType]            NVARCHAR (5)  NULL,
    [BuildingBlockID]             INT           NULL,
    [pnlID]                       INT           NULL,
    [finGeneralLedgerCode]        INT           NULL,
    [finGeneralLedgerCodeDesc]    NVARCHAR (50) NULL,
    [finGeneralLedgerCodeBSh]     INT           NULL,
    [finGeneralLedgerCodeBShDesc] NVARCHAR (50) NULL,
    [finSpendType]                NVARCHAR (15) NULL,
    [importLogID]                 INT           NOT NULL,
    [DisplayOrder]                INT           DEFAULT ((1)) NOT NULL,
    CONSTRAINT [tblPromotionPnLMapping_pk] PRIMARY KEY CLUSTERED ([PromotionPnLMappingID] ASC)
);

