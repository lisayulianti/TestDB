CREATE TABLE [dbo].[tblApprovalMatrix] (
    [ApprovalMatrixID]      INT IDENTITY (1, 1) NOT NULL,
    [countryID]             INT NOT NULL,
    [apmOriginatorRole]     INT NULL,
    [apmApprovalStepRole]   INT NULL,
    [apmApprovalStepNumber] INT NULL,
    CONSTRAINT [tblApprovalMatrix_pk] PRIMARY KEY CLUSTERED ([ApprovalMatrixID] ASC)
);

