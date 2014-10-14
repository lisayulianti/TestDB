CREATE TABLE [dbo].[tblDepartment] (
    [departmentID]              INT           IDENTITY (1, 1) NOT NULL,
    [countryID]                 INT           NOT NULL,
    [depDepartmentName]         NVARCHAR (50) NULL,
    [depDepartmentClientCode]   NVARCHAR (5)  NULL,
    [depUsePromotionPnLMapping] BIT           NULL,
    [depGLcode]                 INT           NULL,
    [depGLcodeDesc]             NVARCHAR (15) NULL,
    [depUseForPromotion]        BIT           CONSTRAINT [DF_tblDepartment_depUseForPromotion] DEFAULT ((0)) NULL,
    [importLogID]               INT           NULL,
    CONSTRAINT [tblDepartment_pk] PRIMARY KEY CLUSTERED ([departmentID] ASC),
    CONSTRAINT [FK_tblDepartment_tblCountry] FOREIGN KEY ([countryID]) REFERENCES [dbo].[tblCountry] ([countryID])
);

