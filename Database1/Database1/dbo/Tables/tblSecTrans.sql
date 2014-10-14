CREATE TABLE [dbo].[tblSecTrans] (
    [countryID]           INT            NULL,
    [dayDate]             DATETIME       NULL,
    [customerID]          INT            NULL,
    [secondaryCustomerID] BIGINT         NULL,
    [productID]           INT            NULL,
    [sctDocument]         NVARCHAR (100) NULL,
    [sctCreditNote]       NVARCHAR (100) NULL,
    [sctInvoice]          NVARCHAR (100) NULL,
    [sctInvQtyEa]         FLOAT (53)     NULL,
    [sctInvVal]           FLOAT (53)     NULL,
    [sctFocQtyEa]         FLOAT (53)     NULL,
    [sctCnQtyEa]          FLOAT (53)     NULL,
    [sctCnVal]            FLOAT (53)     NULL,
    [sctDnQtyEa]          FLOAT (53)     NULL,
    [sctDnVal]            FLOAT (53)     NULL,
    [sctNetQty]           FLOAT (53)     NULL,
    [sctNetVal]           FLOAT (53)     NULL,
    [sctPrmVal]           FLOAT (53)     NULL,
    [importLogID]         INT            NOT NULL
);

