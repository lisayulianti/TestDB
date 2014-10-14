CREATE TABLE [dbo].[tblRecTypeF] (
    [countryID]   INT        NOT NULL,
    [dayDate]     DATETIME   NOT NULL,
    [pnlID]       INT        NOT NULL,
    [customerID]  INT        NULL,
    [productID]   INT        NULL,
    [rtfAmount]   FLOAT (53) NOT NULL,
    [importLogID] INT        NOT NULL
);

