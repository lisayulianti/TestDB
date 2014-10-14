CREATE TABLE [dbo].[tempActualtwo] (
    [countryID]       INT            NULL,
    [pnlID]           INT            NULL,
    [acwClaimDayDate] DATE           NOT NULL,
    [acwPromoDayDate] DATE           NULL,
    [acwPnlActGL]     INT            NOT NULL,
    [acwReference]    NVARCHAR (100) NULL,
    [acwHeader]       NVARCHAR (100) NULL,
    [acwText]         NVARCHAR (100) NULL,
    [acwAmount]       FLOAT (53)     NOT NULL,
    [importLogID]     INT            NOT NULL
);

