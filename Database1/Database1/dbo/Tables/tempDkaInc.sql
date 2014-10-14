CREATE TABLE [dbo].[tempDkaInc] (
    [countryID]         INT            NOT NULL,
    [pnlID]             INT            NULL,
    [dkaPnlActCond]     NVARCHAR (100) NOT NULL,
    [cusGroup6ID]       INT            NULL,
    [dkaCusGroup6Desc]  NVARCHAR (100) NULL,
    [prdGroup11ID]      INT            NULL,
    [dkaPrdGroup11Desc] NVARCHAR (100) NULL,
    [dkaAmount]         FLOAT (53)     NOT NULL,
    [validFrom]         DATETIME       NULL,
    [validTo]           DATETIME       NULL,
    [importLogID]       INT            NOT NULL
);

