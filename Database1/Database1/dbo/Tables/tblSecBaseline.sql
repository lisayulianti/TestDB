CREATE TABLE [dbo].[tblSecBaseline] (
    [monthDate]                      INT            NULL,
    [cusCusGroup5Desc]               NVARCHAR (100) NULL,
    [cusCusGroup6Desc]               NVARCHAR (100) NULL,
    [cusCustomerClientCode]          INT            NULL,
    [cusCustomerName]                NVARCHAR (100) NULL,
    [secSecGroup2ClientCode]         NVARCHAR (100) NULL,
    [secSecondaryCustomerClientCode] NVARCHAR (100) NULL,
    [secSecondaryCustomerName]       NVARCHAR (100) NULL,
    [prdProductClientCode]           INT            NOT NULL,
    [prdProductName]                 NVARCHAR (100) NOT NULL,
    [prdPrdGroup11Desc]              NVARCHAR (100) NULL,
    [prdPrdGroup12Desc]              NVARCHAR (100) NULL,
    [prdPrdGroup13Desc]              NVARCHAR (100) NULL,
    [prdPrdGroup21ClientCode]        NVARCHAR (100) NULL,
    [QtyCTN]                         FLOAT (53)     NULL,
    [QtyEA]                          FLOAT (53)     NULL
);

