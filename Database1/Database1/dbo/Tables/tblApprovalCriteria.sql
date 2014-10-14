CREATE TABLE [dbo].[tblApprovalCriteria] (
    [ApproverCriteriumID]            INT          IDENTITY (1, 1) NOT NULL,
    [countryID]                      INT          NOT NULL,
    [apcCriteriumGroupNumber]        INT          NOT NULL,
    [approvalCriteriumFieldID]       INT          NULL,
    [apcCriteriumComparisonOperator] NVARCHAR (2) NULL,
    [apcCriteriumValue]              FLOAT (53)   NULL,
    CONSTRAINT [tblApprovalCriteria_pk] PRIMARY KEY CLUSTERED ([ApproverCriteriumID] ASC)
);

