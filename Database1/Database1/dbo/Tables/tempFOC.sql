CREATE TABLE [dbo].[tempFOC] (
    [countryID]               INT            NOT NULL,
    [pnlID]                   INT            NULL,
    [focPnlAcrCond]           NVARCHAR (100) NOT NULL,
    [cusGroup1ID]             INT            NULL,
    [focCusGroup1ClientCode]  NVARCHAR (100) NULL,
    [cusGroup7ID]             INT            NULL,
    [focCusGroup7ClientCode]  NVARCHAR (100) NULL,
    [customerID]              INT            NULL,
    [focCustomerClientCode]   INT            NULL,
    [productID]               INT            NULL,
    [focProductClientCode]    INT            NOT NULL,
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

