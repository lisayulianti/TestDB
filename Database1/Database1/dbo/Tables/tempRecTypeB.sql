CREATE TABLE [dbo].[tempRecTypeB] (
    [countryID]             SMALLINT       NOT NULL,
    [dayDate]               DATETIME       NULL,
    [rtbEntryDate]          DATETIME       NULL,
    [pnlID]                 INT            NULL,
    [rtbPnlAcrGL]           INT            NOT NULL,
    [rtbDocItem]            BIGINT         NOT NULL,
    [rtbReference]          NVARCHAR (100) NULL,
    [rtbHeader]             NVARCHAR (100) NULL,
    [rtbText]               NVARCHAR (100) NULL,
    [customerID]            INT            NULL,
    [rtbCustomerClientCode] INT            NULL,
    [productID]             INT            NULL,
    [rtbProductClientCode]  INT            NULL,
    [rtbAmount]             FLOAT (53)     NULL,
    [importLogID]           INT            NOT NULL
);

