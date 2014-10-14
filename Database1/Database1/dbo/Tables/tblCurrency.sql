CREATE TABLE [dbo].[tblCurrency] (
    [currencyID]     INT            NOT NULL,
    [curName]        NVARCHAR (50)  NULL,
    [curSymbol]      NVARCHAR (5)   NULL,
    [curDescription] NVARCHAR (100) NULL,
    CONSTRAINT [PK_tblCurrency] PRIMARY KEY CLUSTERED ([currencyID] ASC)
);

