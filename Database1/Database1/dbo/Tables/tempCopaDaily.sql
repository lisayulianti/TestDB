CREATE TABLE [dbo].[tempCopaDaily] (
    [countryID]             INT            NOT NULL,
    [monthDate]             INT            NULL,
    [pnlID]                 INT            NULL,
    [bwcPnlDesc]            NVARCHAR (100) NOT NULL,
    [customerID]            INT            NULL,
    [bwcCustomerClientCode] INT            NULL,
    [productID]             INT            NULL,
    [bwcProductClientCode]  INT            NULL,
    [bwcAmount]             FLOAT (53)     NULL,
    [importLogID]           INT            NOT NULL
);

