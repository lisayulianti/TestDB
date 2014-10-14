﻿CREATE TABLE [dbo].[tblBudgetAndForecast] (
    [budBudgetNr]       INT           NOT NULL,
    [countryID]         INT           NOT NULL,
    [budYear]           INT           NOT NULL,
    [monthDate]         INT           NOT NULL,
    [prdGroup1ID]       INT           NULL,
    [prdGroup2ID]       INT           NULL,
    [prdGroup3ID]       INT           NULL,
    [prdGroup4ID]       INT           NULL,
    [prdGroup5ID]       INT           NULL,
    [prdGroup6ID]       INT           NULL,
    [prdGroup7ID]       INT           NULL,
    [prdGroup8ID]       INT           NULL,
    [prdGroup9ID]       INT           NULL,
    [prdGroup10ID]      INT           NULL,
    [prdGroup11ID]      INT           NULL,
    [prdGroup12ID]      INT           NULL,
    [prdGroup13ID]      INT           NULL,
    [prdGroup14ID]      INT           NULL,
    [prdGroup15ID]      INT           NULL,
    [prdGroup16ID]      INT           NULL,
    [prdGroup17ID]      INT           NULL,
    [prdGroup18ID]      INT           NULL,
    [prdGroup19ID]      INT           NULL,
    [prdGroup20ID]      INT           NULL,
    [prdGroup21ID]      INT           NULL,
    [prdGroup22ID]      INT           NULL,
    [budParentCode]     NVARCHAR (50) NULL,
    [cusGroup1ID]       INT           NULL,
    [cusGroup2ID]       INT           NULL,
    [cusGroup3ID]       INT           NULL,
    [cusGroup4ID]       INT           NULL,
    [cusGroup5ID]       INT           NULL,
    [cusGroup6ID]       INT           NULL,
    [cusGroup7ID]       INT           NULL,
    [cusGroup8ID]       INT           NULL,
    [secGroup1ID]       INT           NULL,
    [secGroup2ID]       INT           NULL,
    [secGroup3ID]       INT           NULL,
    [secGroup4ID]       INT           NULL,
    [secGroup5ID]       INT           NULL,
    [secGroup6ID]       INT           NULL,
    [budGrossSales]     FLOAT (53)    NULL,
    [budListingFees]    FLOAT (53)    NULL,
    [budTradeSpend]     FLOAT (53)    NULL,
    [budMarketReturn]   FLOAT (53)    NULL,
    [budSAndD]          FLOAT (53)    NULL,
    [budTARO]           FLOAT (53)    NULL,
    [budMaterialCost]   FLOAT (53)    NULL,
    [budProductionCost] FLOAT (53)    NULL,
    [budVariances]      FLOAT (53)    NULL,
    [budGP]             FLOAT (53)    NULL,
    [budGPPerc]         FLOAT (53)    NULL,
    [budAAndPPromo]     FLOAT (53)    NULL,
    [importlogID]       INT           NOT NULL
);

