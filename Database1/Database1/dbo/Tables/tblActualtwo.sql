CREATE TABLE [dbo].[tblActualtwo] (
    [countryID]       INT            NULL,
    [pnlID]           INT            NULL,
    [acwClaimDayDate] DATE           NOT NULL,
    [acwReference]    NVARCHAR (100) NULL,
    [acwHeader]       NVARCHAR (100) NULL,
    [acwText]         NVARCHAR (100) NULL,
    [acwAmount]       FLOAT (53)     NOT NULL,
    [promotionID]     INT            NULL,
    [importLogID]     INT            NOT NULL
);

