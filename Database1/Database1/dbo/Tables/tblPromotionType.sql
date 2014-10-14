CREATE TABLE [dbo].[tblPromotionType] (
    [promotionTypeID]        INT           IDENTITY (1, 1) NOT NULL,
    [countryID]              INT           NULL,
    [ptyPromotionTypeName]   NVARCHAR (50) NULL,
    [ptyPromotionTypeParent] NVARCHAR (50) NULL,
    [ptyDMSCode]             NVARCHAR (2)  NOT NULL,
    [importLogID]            INT           NULL,
    CONSTRAINT [tblPromotionType_pk] PRIMARY KEY CLUSTERED ([promotionTypeID] ASC)
);

