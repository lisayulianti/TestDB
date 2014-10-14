CREATE TABLE [dbo].[tblOutlet] (
    [outletID]                INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NOT NULL,
    [outCustOutletClientCode] NVARCHAR (100) NOT NULL,
    [customerID]              INT            NULL,
    [outCustomerClientCode]   INT            NULL,
    [outOutletClientCode]     NVARCHAR (100) NULL,
    [outOutletDesc]           NVARCHAR (100) NULL,
    [cusGroup6ID]             INT            NULL,
    [outCusGroup6Desc]        NVARCHAR (100) NOT NULL,
    [validFrom]               DATETIME       NOT NULL,
    [validTo]                 DATETIME       NOT NULL,
    [importLogID]             INT            NOT NULL,
    CONSTRAINT [tblOutlet_pk] PRIMARY KEY CLUSTERED ([outletID] ASC)
);

