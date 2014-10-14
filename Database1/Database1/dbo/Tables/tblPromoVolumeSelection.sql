﻿CREATE TABLE [dbo].[tblPromoVolumeSelection] (
    [promoVolumeSelectionID]           INT           IDENTITY (1, 1) NOT NULL,
    [countryID]                        INT           NOT NULL,
    [promotionID]                      NVARCHAR (20) NULL,
    [volCusCustomerValue]              INT           NULL,
    [volPrdProductValue]               INT           NULL,
    [productID]                        INT           NULL,
    [volVolumeP1Base]                  FLOAT (53)    NULL,
    [volVolumeP2Base]                  FLOAT (53)    NULL,
    [volVolumeP3Base]                  FLOAT (53)    NULL,
    [volVolumeP1Plan]                  FLOAT (53)    NULL,
    [volVolumeP2Plan]                  FLOAT (53)    NULL,
    [volVolumeP3Plan]                  FLOAT (53)    NULL,
    [volVolumeP1Actual]                FLOAT (53)    NULL,
    [volVolumeP2Actual]                FLOAT (53)    NULL,
    [volVolumeP3Actual]                FLOAT (53)    NULL,
    [volVolumeP1ActualSellOut]         FLOAT (53)    NULL,
    [volVolumeP2ActualSellOut]         FLOAT (53)    NULL,
    [volVolumeP3ActualSellOut]         FLOAT (53)    NULL,
    [volParticipationpercentagePlan]   FLOAT (53)    NULL,
    [volParticipationpercentageActual] FLOAT (53)    NULL,
    [volCouponRedemptionPlan]          FLOAT (53)    NULL,
    [volCouponRedemptionActual]        FLOAT (53)    NULL,
    [volCardSalesPlan]                 FLOAT (53)    NULL,
    [volCardSalesActual]               FLOAT (53)    NULL,
    CONSTRAINT [tblPromoVolumeSelection_pk] PRIMARY KEY CLUSTERED ([promoVolumeSelectionID] ASC)
);

