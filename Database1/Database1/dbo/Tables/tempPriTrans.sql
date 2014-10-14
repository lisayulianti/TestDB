CREATE TABLE [dbo].[tempPriTrans] (
    [countryID]             INT            NOT NULL,
    [dayDate]               DATETIME       NOT NULL,
    [prtPnlDesc]            NVARCHAR (100) NOT NULL,
    [customerID]            INT            NULL,
    [prtCustomerClientCode] INT            NOT NULL,
    [productID]             INT            NULL,
    [prtProductClientCode]  INT            NOT NULL,
    [prtGrossQuantityCtn]   FLOAT (53)     NULL,
    [prtGrossQuantityEa]    FLOAT (53)     NULL,
    [prtReturnQuantityCtn]  FLOAT (53)     NULL,
    [prtReturnQuantityEa]   FLOAT (53)     NULL,
    [importLogID]           INT            NOT NULL
);

