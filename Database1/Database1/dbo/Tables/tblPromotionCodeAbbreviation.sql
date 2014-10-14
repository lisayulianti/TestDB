CREATE TABLE [dbo].[tblPromotionCodeAbbreviation] (
    [PromotionCodeAbbreviationID] INT          IDENTITY (1, 1) NOT NULL,
    [countryID]                   INT          NULL,
    [PromotionClientCode]         VARCHAR (6)  NOT NULL,
    [pcaDepartment]               VARCHAR (50) NULL,
    [cusGroup6ID]                 INT          NULL,
    [secGroup2ID]                 INT          NULL,
    [prdGroup7ID]                 INT          NULL,
    [departmentID]                INT          NULL,
    [importLogID]                 INT          NULL,
    CONSTRAINT [tblPromotionCodeAbbreviation_pk] PRIMARY KEY CLUSTERED ([PromotionCodeAbbreviationID] ASC),
    CONSTRAINT [FK_tblPromotionCodeAbbreviation_tblDepartment] FOREIGN KEY ([departmentID]) REFERENCES [dbo].[tblDepartment] ([departmentID])
);

