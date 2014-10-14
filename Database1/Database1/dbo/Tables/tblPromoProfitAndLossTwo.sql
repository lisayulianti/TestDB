CREATE TABLE [dbo].[tblPromoProfitAndLossTwo] (
    [promoProfitAndLossTwoID] INT           IDENTITY (1, 1) NOT NULL,
    [countryID]               INT           NOT NULL,
    [promotionID]             INT           NULL,
    [pnlitem]                 NVARCHAR (40) NULL,
    [finCostTypeID]           INT           NULL,
    [finAmount]               FLOAT (53)    NULL,
    CONSTRAINT [tblPromoProfitAndLossTwoID_pk] PRIMARY KEY CLUSTERED ([promoProfitAndLossTwoID] ASC)
);

