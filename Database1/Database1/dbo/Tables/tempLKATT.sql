CREATE TABLE [dbo].[tempLKATT] (
    [countryID]               INT            NULL,
    [pnlID]                   INT            NULL,
    [lkaPnlAcrGL]             INT            NOT NULL,
    [secGroup2ID]             INT            NULL,
    [lkaSecGroup2ClientCode]  NVARCHAR (100) NOT NULL,
    [prdGroup11ID]            INT            NULL,
    [lkaPrdGroup11ClientCode] NVARCHAR (100) NOT NULL,
    [lkaAmount]               FLOAT (53)     NOT NULL,
    [validFrom]               DATE           NOT NULL,
    [validTo]                 DATE           NOT NULL,
    [importLogID]             INT            NOT NULL
);

