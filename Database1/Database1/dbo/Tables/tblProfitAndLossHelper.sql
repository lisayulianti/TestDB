CREATE TABLE [dbo].[tblProfitAndLossHelper] (
    [PnLHelperID]      INT           IDENTITY (1, 1) NOT NULL,
    [countryID]        INT           NOT NULL,
    [PnlGroup]         VARCHAR (50)  NULL,
    [PnLSubGroup]      VARCHAR (50)  NULL,
    [PnLSubGroupItem]  VARCHAR (50)  NULL,
    [PnLCode]          INT           NULL,
    [GLCode]           INT           NULL,
    [PnLItem]          NVARCHAR (50) NULL,
    [PnLOrder]         INT           NULL,
    [PnLDesc]          NVARCHAR (50) NULL,
    [PnLSubDesc]       NVARCHAR (50) NULL,
    [PnLSubOrder]      INT           NULL,
    [IncludedInBudget] BIT           CONSTRAINT [DF_tblProfitAndLossHelper_IncludedInBudget] DEFAULT ((0)) NOT NULL,
    [PnLCodeForFTT]    INT           NULL,
    [importLogID]      INT           NULL,
    CONSTRAINT [PK_tblProfitAndLossHelper] PRIMARY KEY CLUSTERED ([PnLHelperID] ASC),
    CONSTRAINT [FK_tblProfitAndLossHelper_tblCountry] FOREIGN KEY ([countryID]) REFERENCES [dbo].[tblCountry] ([countryID])
);

