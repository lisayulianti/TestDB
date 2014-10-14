CREATE TABLE [dbo].[tempExtTrans] (
    [countryID]               INT            NOT NULL,
    [dayDate]                 DATE           NOT NULL,
    [cusGroup6ID]             INT            NULL,
    [extCusGroup6Desc]        NVARCHAR (100) NULL,
    [outletID]                INT            NULL,
    [extCustOutletClientCode] NVARCHAR (100) NULL,
    [customerID]              INT            NULL,
    [extCustomerClientCode]   INT            NULL,
    [extOutletClientCode]     NVARCHAR (100) NULL,
    [extOutletDesc]           NVARCHAR (100) NULL,
    [skuID]                   INT            NULL,
    [extCustSkuClientCode]    NVARCHAR (100) NULL,
    [productID]               INT            NULL,
    [extProductClientCode]    INT            NULL,
    [extSkuClientCode]        NVARCHAR (100) NULL,
    [extSkuDesc]              NVARCHAR (100) NULL,
    [extExtConvFactor]        FLOAT (53)     NULL,
    [extScanQuantity]         FLOAT (53)     NOT NULL,
    [extSalesQuantityEa]      FLOAT (53)     NULL,
    [importLogID]             INT            NOT NULL,
    [extExcel]                NVARCHAR (50)  NULL
);

