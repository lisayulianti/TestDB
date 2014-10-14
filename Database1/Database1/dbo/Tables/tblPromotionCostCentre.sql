CREATE TABLE [dbo].[tblPromotionCostCentre] (
    [PromotionCostCenterID] INT            IDENTITY (1, 1) NOT NULL,
    [countryID]             INT            NOT NULL,
    [pccCostCentre]         INT            NULL,
    [pccCostCentreDesc]     NVARCHAR (255) NULL,
    [importLogID]           INT            NULL,
    CONSTRAINT [PK_tblPromotionCostCentre] PRIMARY KEY CLUSTERED ([PromotionCostCenterID] ASC)
);

