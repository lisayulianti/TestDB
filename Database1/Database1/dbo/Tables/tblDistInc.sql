CREATE TABLE [dbo].[tblDistInc] (
    [countryID]    INT        NOT NULL,
    [pnlID]        INT        NULL,
    [customerID]   INT        NULL,
    [prdGroup19ID] INT        NULL,
    [disAmount]    FLOAT (53) NOT NULL,
    [validFrom]    DATETIME   NOT NULL,
    [validTo]      DATETIME   NOT NULL,
    [importLogID]  INT        NOT NULL
);

