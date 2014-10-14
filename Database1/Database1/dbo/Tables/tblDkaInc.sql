CREATE TABLE [dbo].[tblDkaInc] (
    [countryID]    INT        NOT NULL,
    [pnlID]        INT        NULL,
    [cusGroup6ID]  INT        NULL,
    [prdGroup11ID] INT        NULL,
    [dkaAmount]    FLOAT (53) NOT NULL,
    [validFrom]    DATETIME   NULL,
    [validTo]      DATETIME   NULL,
    [importLogID]  INT        NOT NULL
);

