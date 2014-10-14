CREATE TABLE [dbo].[tblFOC] (
    [countryID]               INT            NOT NULL,
    [pnlID]                   INT            NULL,
    [cusGroup1ID]             INT            NULL,
    [cusGroup7ID]             INT            NULL,
    [customerID]              INT            NULL,
    [productID]               INT            NULL,
    [focMinQty]               FLOAT (53)     NOT NULL,
    [focMinQtyUOMClientCode]  NVARCHAR (100) NOT NULL,
    [focQualQty]              FLOAT (53)     NOT NULL,
    [focQualQtyUOMClientCode] NVARCHAR (100) NOT NULL,
    [focFreeQty]              FLOAT (53)     NOT NULL,
    [focFreeQtyUOMClientCode] NVARCHAR (100) NOT NULL,
    [validFrom]               DATETIME       NOT NULL,
    [validTo]                 DATETIME       NOT NULL,
    [combinationID]           INT            NOT NULL,
    [importLogID]             INT            NULL
);

