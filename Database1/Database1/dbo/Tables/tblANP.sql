CREATE TABLE [dbo].[tblANP] (
    [countryID]    INT        NULL,
    [monthDate]    INT        NOT NULL,
    [pnlID]        INT        NULL,
    [customerID]   INT        NULL,
    [prdGroup11ID] INT        NULL,
    [prdGroup12ID] INT        NULL,
    [prdGroup13ID] INT        NULL,
    [productID]    INT        NULL,
    [anpAmount]    FLOAT (53) NOT NULL,
    [importLogID]  INT        NOT NULL
);

