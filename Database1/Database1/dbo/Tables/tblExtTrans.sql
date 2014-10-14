CREATE TABLE [dbo].[tblExtTrans] (
    [countryID]          INT           NOT NULL,
    [dayDate]            DATE          NOT NULL,
    [cusGroup6ID]        INT           NULL,
    [outletID]           INT           NULL,
    [customerID]         INT           NULL,
    [skuID]              INT           NULL,
    [productID]          INT           NULL,
    [extExtConvFactor]   FLOAT (53)    NULL,
    [extScanQuantity]    FLOAT (53)    NOT NULL,
    [extSalesQuantityEa] FLOAT (53)    NULL,
    [importLogID]        INT           NOT NULL,
    [extExcel]           NVARCHAR (50) NULL
);

