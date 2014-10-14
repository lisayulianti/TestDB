﻿CREATE TABLE [dbo].[tblProduct] (
    [productID]               INT            NULL,
    [countryID]               INT            NOT NULL,
    [prdProductClientCode]    INT            NOT NULL,
    [prdProductName]          NVARCHAR (100) NOT NULL,
    [prdGroup1ID]             INT            NULL,
    [prdPrdGroup1ClientCode]  NVARCHAR (100) NULL,
    [prdPrdGroup1Desc]        NVARCHAR (100) NULL,
    [prdGroup2ID]             INT            NULL,
    [prdPrdGroup2ClientCode]  NVARCHAR (100) NULL,
    [prdPrdGroup2Desc]        NVARCHAR (100) NULL,
    [prdGroup3ID]             INT            NULL,
    [prdPrdGroup3ClientCode]  NVARCHAR (100) NULL,
    [prdPrdGroup3Desc]        NVARCHAR (100) NULL,
    [prdGroup4ID]             INT            NULL,
    [prdPrdGroup4ClientCode]  NVARCHAR (100) NULL,
    [prdPrdGroup4Desc]        NVARCHAR (100) NULL,
    [prdGroup5ID]             INT            NULL,
    [prdPrdGroup5ClientCode]  NVARCHAR (100) NULL,
    [prdPrdGroup5Desc]        NVARCHAR (100) NULL,
    [prdGroup6ID]             INT            NULL,
    [prdPrdGroup6ClientCode]  NVARCHAR (100) NULL,
    [prdPrdGroup6Desc]        NVARCHAR (100) NULL,
    [prdGroup7ID]             INT            NULL,
    [prdPrdGroup7ClientCode]  NVARCHAR (100) NULL,
    [prdPrdGroup7Desc]        NVARCHAR (100) NULL,
    [prdGroup8ID]             INT            NULL,
    [prdPrdGroup8ClientCode]  NVARCHAR (100) NULL,
    [prdPrdGroup8Desc]        NVARCHAR (100) NULL,
    [prdGroup9ID]             INT            NULL,
    [prdPrdGroup9ClientCode]  NVARCHAR (100) NULL,
    [prdPrdGroup9Desc]        NVARCHAR (100) NULL,
    [prdGroup10ID]            INT            NULL,
    [prdPrdGroup10ClientCode] NVARCHAR (100) NULL,
    [prdPrdGroup10Desc]       NVARCHAR (100) NULL,
    [prdGroup11ID]            INT            NULL,
    [prdPrdGroup11ClientCode] NVARCHAR (100) NULL,
    [prdPrdGroup11Desc]       NVARCHAR (100) NULL,
    [prdGroup12ID]            INT            NULL,
    [prdPrdGroup12ClientCode] NVARCHAR (100) NULL,
    [prdPrdGroup12Desc]       NVARCHAR (100) NULL,
    [prdGroup13ID]            INT            NULL,
    [prdPrdGroup13ClientCode] NVARCHAR (100) NULL,
    [prdPrdGroup13Desc]       NVARCHAR (100) NULL,
    [prdGroup14ID]            INT            NULL,
    [prdPrdGroup14ClientCode] NVARCHAR (100) NULL,
    [prdPrdGroup14Desc]       NVARCHAR (100) NULL,
    [prdGroup15ID]            INT            NULL,
    [prdPrdGroup15ClientCode] NVARCHAR (100) NULL,
    [prdPrdGroup15Desc]       NVARCHAR (100) NULL,
    [prdGroup16ID]            INT            NULL,
    [prdPrdGroup16ClientCode] NVARCHAR (100) NULL,
    [prdPrdGroup16Desc]       NVARCHAR (100) NULL,
    [prdGroup17ID]            INT            NULL,
    [prdPrdGroup17ClientCode] NVARCHAR (100) NULL,
    [prdPrdGroup17Desc]       NVARCHAR (100) NULL,
    [prdGroup18ID]            INT            NULL,
    [prdPrdGroup18ClientCode] NVARCHAR (100) NULL,
    [prdPrdGroup18Desc]       NVARCHAR (100) NULL,
    [prdGroup19ID]            INT            NULL,
    [prdPrdGroup19ClientCode] NVARCHAR (100) NULL,
    [prdPrdGroup19Desc]       NVARCHAR (100) NULL,
    [prdGroup20ID]            INT            NULL,
    [prdPrdGroup20ClientCode] NVARCHAR (100) NULL,
    [prdPrdGroup20Desc]       NVARCHAR (100) NULL,
    [prdGroup21ID]            INT            NULL,
    [prdPrdGroup21ClientCode] NVARCHAR (100) NULL,
    [prdPrdGroup21Desc]       NVARCHAR (100) NULL,
    [prdGroup22ID]            INT            NULL,
    [prdPrdGroup22ClientCode] NVARCHAR (100) NULL,
    [prdPrdGroup22Desc]       NVARCHAR (100) NULL,
    [prdNetWeight]            FLOAT (53)     NULL,
    [prdNetVolume]            FLOAT (53)     NULL,
    [prdGST]                  FLOAT (53)     NULL,
    [prdConversionFactor]     FLOAT (53)     NULL,
    [prdParentCode]           NVARCHAR (100) NULL,
    [createdOn]               DATETIME       NULL,
    [validFrom]               DATETIME       NULL,
    [validTo]                 DATETIME       NULL,
    [importLogID]             INT            NOT NULL,
    [prdProductParentID]      INT            NULL
);

