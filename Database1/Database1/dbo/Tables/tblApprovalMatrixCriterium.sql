CREATE TABLE [dbo].[tblApprovalMatrixCriterium] (
    [ApprovalMatrixCriteriumID] INT IDENTITY (1, 1) NOT NULL,
    [ApprovalMatrixID]          INT NOT NULL,
    [ApprovalCriteriumID]       INT NOT NULL,
    CONSTRAINT [PK_ApprovalMatrixCriterium] PRIMARY KEY CLUSTERED ([ApprovalMatrixCriteriumID] ASC)
);

