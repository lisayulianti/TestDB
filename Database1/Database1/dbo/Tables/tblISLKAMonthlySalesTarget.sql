CREATE TABLE [dbo].[tblISLKAMonthlySalesTarget] (
    [ISLKAMonthlySalesTargetID] INT        IDENTITY (1, 1) NOT NULL,
    [countryID]                 INT        NOT NULL,
    [mstYear]                   INT        NULL,
    [mstMonth]                  INT        NULL,
    [secGroup2ID]               INT        NOT NULL,
    [cusGroup6ID]               INT        NOT NULL,
    [mstGSVTarget]              FLOAT (53) NULL,
    [importlogID]               INT        NOT NULL,
    CONSTRAINT [tblISLKAMonthlySalesTarget_pk] PRIMARY KEY CLUSTERED ([ISLKAMonthlySalesTargetID] ASC)
);

