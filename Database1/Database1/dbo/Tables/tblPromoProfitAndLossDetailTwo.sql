CREATE TABLE [dbo].[tblPromoProfitAndLossDetailTwo] (
    [promoProfitAndLossDetailTwoID] INT           IDENTITY (1, 1) NOT NULL,
    [promoProfitAndLossTwoID]       INT           NOT NULL,
    [promotionID]                   INT           NOT NULL,
    [pnlSubItem]                    NVARCHAR (50) NULL,
    [finCostTypeID]                 INT           NULL,
    [finAmount]                     FLOAT (53)    NULL,
    CONSTRAINT [PK_tblPromoProfitAndLossDetailTwo] PRIMARY KEY CLUSTERED ([promoProfitAndLossDetailTwoID] ASC),
    CONSTRAINT [FK_tblPromoProfitAndLossDetailTwo_tblPromoProfitAndLossTwo] FOREIGN KEY ([promoProfitAndLossTwoID]) REFERENCES [dbo].[tblPromoProfitAndLossTwo] ([promoProfitAndLossTwoID])
);

