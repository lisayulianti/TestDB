CREATE TABLE [dbo].[tblApprovalCriteriumField] (
    [approvalCriteriumFieldId] INT            IDENTITY (1, 1) NOT NULL,
    [countryID]                INT            NULL,
    [acfDisplayedFieldName]    NVARCHAR (200) NULL,
    [acfQuery]                 TEXT           NULL,
    [acfFrom]                  TEXT           NULL,
    [acfWhere]                 TEXT           NULL,
    [acfFieldType]             NVARCHAR (200) NULL,
    [acfOptions]               NVARCHAR (200) NULL,
    CONSTRAINT [tblApprovalCriteriumField_pk] PRIMARY KEY CLUSTERED ([approvalCriteriumFieldId] ASC)
);

