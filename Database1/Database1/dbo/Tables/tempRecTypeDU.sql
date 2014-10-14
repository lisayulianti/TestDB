CREATE TABLE [dbo].[tempRecTypeDU] (
    [countryID]             INT            NOT NULL,
    [dayDate]               DATETIME       NOT NULL,
    [pnlID]                 INT            NULL,
    [rtuPnlDesc]            NVARCHAR (100) NOT NULL,
    [rtuRecType]            NVARCHAR (100) NOT NULL,
    [customerID]            INT            NULL,
    [rtuCustomerClientCode] NVARCHAR (100) NULL,
    [productID]             INT            NULL,
    [rtuProductClientCode]  NVARCHAR (100) NULL,
    [rtuAmount]             FLOAT (53)     NOT NULL,
    [importLogID]           INT            NOT NULL
);

