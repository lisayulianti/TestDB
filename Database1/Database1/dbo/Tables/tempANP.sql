CREATE TABLE [dbo].[tempANP] (
    [countryID]               INT            NULL,
    [monthDate]               INT            NOT NULL,
    [pnlID]                   INT            NULL,
    [anpPnlClientDesc]        NVARCHAR (100) NOT NULL,
    [customerID]              INT            NULL,
    [anpCustomerClientCode]   INT            NULL,
    [prdGroup11ID]            INT            NULL,
    [anpPrdGroup11ClientCode] NVARCHAR (100) NULL,
    [prdGroup12ID]            INT            NULL,
    [anpPrdGroup12ClientCode] NVARCHAR (100) NULL,
    [prdGroup13ID]            INT            NULL,
    [anpPrdGroup13ClientCode] NVARCHAR (100) NULL,
    [productID]               INT            NULL,
    [anpProductClientCode]    INT            NULL,
    [anpAmount]               FLOAT (53)     NOT NULL,
    [importLogID]             INT            NOT NULL
);

