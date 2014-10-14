CREATE TABLE [dbo].[tblPromotionCategory] (
    [PromotionCategoryID] INT            IDENTITY (1, 1) NOT NULL,
    [PrdCat_Cd]           NVARCHAR (255) NULL,
    [PrdCat_Desc]         NVARCHAR (255) NULL,
    [countryID]           INT            NULL,
    [importLogID]         INT            NULL,
    CONSTRAINT [PK_tblPromotionCategory] PRIMARY KEY CLUSTERED ([PromotionCategoryID] ASC)
);

