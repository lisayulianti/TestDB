CREATE TABLE [dbo].[tblPriTrans] (
    [countryID]            INT        NOT NULL,
    [dayDate]              DATETIME   NOT NULL,
    [customerID]           INT        NOT NULL,
    [productID]            INT        NOT NULL,
    [prtGrossQuantityCtn]  FLOAT (53) NULL,
    [prtGrossQuantityEa]   FLOAT (53) NULL,
    [prtReturnQuantityCtn] FLOAT (53) NULL,
    [prtReturnQuantityEa]  FLOAT (53) NULL,
    [importLogID]          INT        NOT NULL
);

