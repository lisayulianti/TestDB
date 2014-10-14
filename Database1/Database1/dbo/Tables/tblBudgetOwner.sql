CREATE TABLE [dbo].[tblBudgetOwner] (
    [BudgetOwnerID]             INT           IDENTITY (1, 1) NOT NULL,
    [countryID]                 INT           NULL,
    [bdoBudgetOwnerClientCode]  NVARCHAR (5)  NULL,
    [bdoBudgetOwnerClientName]  NVARCHAR (20) NULL,
    [bdoUsePromotionPnLMapping] BIT           NOT NULL,
    [bdoGLcode]                 INT           NULL,
    [bdoGLcodeDesc]             VARCHAR (15)  NULL,
    [importLogID]               INT           NULL,
    CONSTRAINT [tblBudgetOwner_pk] PRIMARY KEY CLUSTERED ([BudgetOwnerID] ASC)
);

