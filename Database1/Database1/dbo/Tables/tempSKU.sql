CREATE TABLE [dbo].[tempSKU] (
    [skuID]                INT            NOT NULL,
    [countryID]            INT            NOT NULL,
    [skuCustSkuClientCode] NVARCHAR (100) NOT NULL,
    [productID]            INT            NULL,
    [skuProductClientCode] INT            NULL,
    [skuSkuClientCode]     NVARCHAR (100) NULL,
    [skuSkuDesc]           NVARCHAR (100) NULL,
    [skuExtConvFactor]     FLOAT (53)     NULL,
    [cusGroup6ID]          INT            NULL,
    [skuCusGroup6Desc]     NVARCHAR (100) NOT NULL,
    [validFrom]            DATETIME       NOT NULL,
    [validTo]              DATETIME       NOT NULL,
    [importLogID]          INT            NOT NULL
);

