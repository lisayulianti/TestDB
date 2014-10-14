CREATE TABLE [dbo].[tblDepartmentPromoType] (
    [departmentPromoType] INT IDENTITY (1, 1) NOT NULL,
    [countryID]           INT NOT NULL,
    [promotionTypeID]     INT NOT NULL,
    [departmentID]        INT NOT NULL,
    CONSTRAINT [PK_tblDepartmentPromoType] PRIMARY KEY CLUSTERED ([departmentPromoType] ASC),
    CONSTRAINT [FK_tblDepartmentPromoType_tblCountry] FOREIGN KEY ([countryID]) REFERENCES [dbo].[tblCountry] ([countryID]),
    CONSTRAINT [FK_tblDepartmentPromoType_tblDepartment] FOREIGN KEY ([departmentID]) REFERENCES [dbo].[tblDepartment] ([departmentID]),
    CONSTRAINT [FK_tblDepartmentPromoType_tblPromotionType] FOREIGN KEY ([promotionTypeID]) REFERENCES [dbo].[tblPromotionType] ([promotionTypeID])
);

