CREATE TABLE [dbo].[tempActual] (
    [countryID]             INT            NULL,
    [pnlID]                 INT            NULL,
    [actPnlActCond]         NVARCHAR (100) NOT NULL,
    [actPnlActGL]           INT            NULL,
    [actClaimDayDate]       DATE           NULL,
    [actPromoDayDate]       DATE           NULL,
    [actReference]          NVARCHAR (100) NOT NULL,
    [actHeader]             NVARCHAR (100) NULL,
    [actText]               NVARCHAR (100) NULL,
    [actRoiClientCode]      NVARCHAR (100) NULL,
    [customerID]            INT            NULL,
    [actCustomerClientCode] NVARCHAR (100) NOT NULL,
    [productID]             INT            NULL,
    [actProductClientCode]  NVARCHAR (100) NOT NULL,
    [actAmount]             FLOAT (53)     NOT NULL,
    [promotionID]           INT            NULL,
    [importLogID]           INT            NOT NULL
);

