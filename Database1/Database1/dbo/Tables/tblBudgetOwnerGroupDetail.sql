CREATE TABLE [dbo].[tblBudgetOwnerGroupDetail] (
    [budgetOwnerGroupDetailID] INT IDENTITY (1, 1) NOT NULL,
    [budgetOwnerGroupID]       INT NOT NULL,
    [cusGroup1ID]              INT NULL,
    [cusGroup5ID]              INT NULL,
    [cusGroup6ID]              INT NULL,
    [secGroup2ID]              INT NULL,
    [countryID]                INT NULL,
    [importLogID]              INT NULL,
    CONSTRAINT [PK_tblBudgetOwnerGroup] PRIMARY KEY CLUSTERED ([budgetOwnerGroupDetailID] ASC),
    CONSTRAINT [FK_tblBudgetOwnerGroup_tblCusGroup1] FOREIGN KEY ([cusGroup1ID]) REFERENCES [dbo].[tblCusGroup1] ([cusGroup1ID]),
    CONSTRAINT [FK_tblBudgetOwnerGroup_tblCusGroup5] FOREIGN KEY ([cusGroup5ID]) REFERENCES [dbo].[tblCusGroup5] ([cusGroup5ID]),
    CONSTRAINT [FK_tblBudgetOwnerGroup_tblCusGroup6] FOREIGN KEY ([cusGroup6ID]) REFERENCES [dbo].[tblCusGroup6] ([cusGroup6ID]),
    CONSTRAINT [FK_tblBudgetOwnerGroupDetail_tblBudgetOwnerGroup] FOREIGN KEY ([budgetOwnerGroupID]) REFERENCES [dbo].[tblBudgetOwnerGroup] ([budgetOwnerGroupID])
);

