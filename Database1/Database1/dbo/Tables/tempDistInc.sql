CREATE TABLE [dbo].[tempDistInc] (
    [countryID]               INT            NOT NULL,
    [pnlID]                   INT            NULL,
    [disPnlActCond]           NVARCHAR (100) NOT NULL,
    [customerID]              INT            NULL,
    [disCustomerClientCode]   INT            NOT NULL,
    [prdGroup19ID]            INT            NULL,
    [disPrdGroup19ClientCode] NVARCHAR (100) NULL,
    [disAmount]               FLOAT (53)     NOT NULL,
    [validFrom]               DATETIME       NOT NULL,
    [validTo]                 DATETIME       NOT NULL,
    [importLogID]             INT            NOT NULL
);

