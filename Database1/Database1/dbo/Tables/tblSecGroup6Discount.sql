CREATE TABLE [dbo].[tblSecGroup6Discount] (
    [secGroup6DiscountID]    INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NOT NULL,
    [secGroup6ID]            INT            NULL,
    [s06SecGroup6ClientCode] NVARCHAR (100) NULL,
    [secFPercentage]         FLOAT (53)     NULL,
    [validFrom]              DATETIME       NULL,
    [validTo]                DATETIME       NULL,
    [importlogID]            INT            NOT NULL,
    CONSTRAINT [PK_tblSecGroup6Discount] PRIMARY KEY CLUSTERED ([secGroup6DiscountID] ASC)
);

