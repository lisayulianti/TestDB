CREATE TABLE [dbo].[tblActual] (
    [countryID]        INT            NULL,
    [pnlID]            INT            NULL,
    [actClaimDayDate]  DATE           NULL,
    [actPromoDayDate]  DATE           NULL,
    [actReference]     NVARCHAR (100) NOT NULL,
    [actHeader]        NVARCHAR (100) NULL,
    [actText]          NVARCHAR (100) NULL,
    [actRoiClientCode] NVARCHAR (100) NULL,
    [customerID]       INT            NULL,
    [productID]        INT            NULL,
    [actAmount]        FLOAT (53)     NOT NULL,
    [promotionID]      INT            NULL,
    [importLogID]      INT            NOT NULL,
    CONSTRAINT [FK_tblActual_tblPromotion] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[tblPromotion] ([promotionID])
);

