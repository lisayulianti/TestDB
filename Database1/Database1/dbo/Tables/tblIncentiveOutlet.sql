CREATE TABLE [dbo].[tblIncentiveOutlet] (
    [incentiveOutletID]   INT        IDENTITY (1, 1) NOT NULL,
    [countryID]           INT        NOT NULL,
    [secondaryCustomerID] INT        NULL,
    [inoClass]            FLOAT (53) NULL,
    [importlogID]         INT        NOT NULL,
    CONSTRAINT [tblIncentiveOutlet_pk] PRIMARY KEY CLUSTERED ([incentiveOutletID] ASC)
);

