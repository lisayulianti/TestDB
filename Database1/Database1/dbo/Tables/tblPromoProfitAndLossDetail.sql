CREATE TABLE [dbo].[tblPromoProfitAndLossDetail] (
    [promoProfitAndLossDetailID] INT           IDENTITY (1, 1) NOT NULL,
    [promoProfitAndLossID]       INT           NOT NULL,
    [promotionID]                INT           NOT NULL,
    [pnlSubItem]                 NVARCHAR (50) NULL,
    [finCostTypeID]              INT           NULL,
    [finAmount]                  FLOAT (53)    NULL,
    CONSTRAINT [PK_tblPromoProfitAndLossDetail] PRIMARY KEY CLUSTERED ([promoProfitAndLossDetailID] ASC),
    CONSTRAINT [FK_tblPromoProfitAndLossDetail_tblPromoProfitAndLoss] FOREIGN KEY ([promoProfitAndLossID]) REFERENCES [dbo].[tblPromoProfitAndLoss] ([promoProfitAndLossID])
);

