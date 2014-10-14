CREATE TABLE [dbo].[tempRecTypeF] (
    [countryID]             INT            NOT NULL,
    [dayDate]               DATETIME       NOT NULL,
    [pnlID]                 INT            NULL,
    [rtfPnlAcrCond]         NVARCHAR (100) NOT NULL,
    [customerID]            INT            NULL,
    [rtfCustomerClientCode] INT            NOT NULL,
    [productID]             INT            NULL,
    [rtfProductClientCode]  INT            NOT NULL,
    [rtfAmount]             FLOAT (53)     NOT NULL,
    [importLogID]           INT            NOT NULL
);

