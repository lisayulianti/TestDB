CREATE TABLE [dbo].[tblApprovalStatus] (
    [ApprovalStatusID]  INT          IDENTITY (1, 1) NOT NULL,
    [apsApprovalStatus] VARCHAR (50) NULL,
    CONSTRAINT [tblApprovalStatus_pk] PRIMARY KEY CLUSTERED ([ApprovalStatusID] ASC)
);

