﻿CREATE TABLE [dbo].[tblPromotionCustomerSelection] (
    [promotionCustomerSelectionID] INT        IDENTITY (1, 1) NOT NULL,
    [promotionID]                  INT        NULL,
    [pslSelAllCusGroup1]           BIT        NULL,
    [pslSelAllCusGroup2]           BIT        NULL,
    [pslSelAllCusGroup3]           BIT        NULL,
    [pslSelAllCusGroup4]           BIT        NULL,
    [pslSelAllCusGroup5]           BIT        NULL,
    [pslSelAllCusGroup6]           BIT        NULL,
    [pslSelAllCusGroup7]           BIT        NULL,
    [pslSelAllSecGroup1]           BIT        NULL,
    [pslSelAllSecGroup2]           BIT        NULL,
    [pslSelAllSecGroup3]           BIT        NULL,
    [cusGroup1ID]                  INT        NULL,
    [cusGroup2ID]                  INT        NULL,
    [cusGroup3ID]                  INT        NULL,
    [cusGroup4ID]                  INT        NULL,
    [cusGroup5ID]                  INT        NULL,
    [cusGroup6ID]                  INT        NULL,
    [cusGroup7ID]                  INT        NULL,
    [customerID]                   INT        NULL,
    [secGroup1ID]                  INT        NULL,
    [secGroup2ID]                  INT        NULL,
    [secGroup3ID]                  INT        NULL,
    [secondarycustomerID]          INT        NULL,
    [countryID]                    INT        CONSTRAINT [DF_tblPromotionCustomerSelection_countryID] DEFAULT ('102') NOT NULL,
    [pslSelAllSecGroup4]           BIT        NULL,
    [secGroup4ID]                  INT        NULL,
    [secFPercentage]               FLOAT (53) NULL,
    [pslSelAllFPercentage]         BIT        NULL,
    [outletID]                     INT        NULL,
    [secGroup5ID]                  INT        NULL,
    [pslSelAllSecGroup5]           BIT        NULL,
    [pslSelAllOutlet]              BIT        NULL,
    [pslSelAllSecondaryCustomer]   BIT        NULL,
    [pslSelAllCustomer]            BIT        NULL,
    [secGroup6ID]                  INT        NULL,
    [pslSelAllSecGroup6]           BIT        NULL
);

