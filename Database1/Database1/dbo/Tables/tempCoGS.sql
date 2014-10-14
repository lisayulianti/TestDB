CREATE TABLE [dbo].[tempCoGS] (
    [countryID]            INT        NOT NULL,
    [productID]            INT        NULL,
    [cgsProductClientCode] INT        NOT NULL,
    [cgsAmount]            FLOAT (53) NOT NULL,
    [validFrom]            DATETIME   NOT NULL,
    [validTo]              DATETIME   NOT NULL,
    [importLogID]          INT        NOT NULL
);

