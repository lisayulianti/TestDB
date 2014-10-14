CREATE TABLE [dbo].[tblPromoProfitAndLoss] (
    [promoProfitAndLossID] INT           IDENTITY (1, 1) NOT NULL,
    [promotionID]          INT           NULL,
    [pnlitem]              NVARCHAR (40) NULL,
    [finCostTypeID]        INT           NULL,
    [finAmount]            FLOAT (53)    NULL,
    CONSTRAINT [tblPromoProfitAndLoss_pk] PRIMARY KEY CLUSTERED ([promoProfitAndLossID] ASC)
);

