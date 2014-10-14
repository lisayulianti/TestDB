﻿CREATE TABLE [dbo].[tempCustomer] (
    [customerID]             INT            NOT NULL,
    [countryID]              INT            NOT NULL,
    [cusCustomerClientCode]  INT            NOT NULL,
    [cusCustomerName]        NVARCHAR (100) NOT NULL,
    [cusGroup1ID]            INT            NULL,
    [cusCusGroup1ClientCode] NVARCHAR (100) NULL,
    [cusCusGroup1Desc]       NVARCHAR (100) NULL,
    [cusGroup2ID]            INT            NULL,
    [cusCusGroup2ClientCode] NVARCHAR (100) NULL,
    [cusCusGroup2Desc]       NVARCHAR (100) NULL,
    [cusGroup3ID]            INT            NULL,
    [cusCusGroup3ClientCode] NVARCHAR (100) NULL,
    [cusCusGroup3Desc]       NVARCHAR (100) NULL,
    [cusGroup4ID]            INT            NULL,
    [cusCusGroup4ClientCode] NVARCHAR (100) NULL,
    [cusCusGroup4Desc]       NVARCHAR (100) NULL,
    [cusGroup5ID]            INT            NULL,
    [cusCusGroup5ClientCode] NVARCHAR (100) NULL,
    [cusCusGroup5Desc]       NVARCHAR (100) NULL,
    [cusGroup6ID]            INT            NULL,
    [cusCusGroup6ClientCode] NVARCHAR (100) NULL,
    [cusCusGroup6Desc]       NVARCHAR (100) NULL,
    [cusGroup7ID]            INT            NULL,
    [cusCusGroup7ClientCode] NVARCHAR (100) NULL,
    [cusCusGroup7Desc]       NVARCHAR (100) NULL,
    [cusGST]                 INT            NULL,
    [createdOn]              DATETIME       NOT NULL,
    [validFrom]              DATETIME       NOT NULL,
    [validTo]                DATETIME       NOT NULL,
    [importLogID]            INT            NOT NULL
);

