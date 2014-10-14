CREATE TABLE [dbo].[tblRecTypeDU] (
    [countryID]   INT        NOT NULL,
    [dayDate]     DATETIME   NOT NULL,
    [pnlID]       INT        NULL,
    [customerID]  INT        NULL,
    [productID]   INT        NULL,
    [rtuAmount]   FLOAT (53) NOT NULL,
    [importLogID] INT        NOT NULL
);

