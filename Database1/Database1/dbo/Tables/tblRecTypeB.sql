CREATE TABLE [dbo].[tblRecTypeB] (
    [countryID]    SMALLINT       NOT NULL,
    [dayDate]      DATETIME       NOT NULL,
    [rtbEntryDate] DATETIME       NULL,
    [pnlID]        INT            NULL,
    [rtbDocItem]   BIGINT         NOT NULL,
    [rtbReference] NVARCHAR (100) NULL,
    [rtbHeader]    NVARCHAR (100) NULL,
    [rtbText]      NVARCHAR (100) NULL,
    [customerID]   INT            NULL,
    [productID]    INT            NULL,
    [rtbAmount]    FLOAT (53)     NULL,
    [importLogID]  INT            NOT NULL,
    [promotionID]  INT            NULL,
    CONSTRAINT [FK_tblRecTypeB_tblPromotion] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[tblPromotion] ([promotionID])
);

