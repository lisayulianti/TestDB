CREATE TABLE [dbo].[tblProfitAndLossCriteria] (
    [ProfitAndLossCriteriaID] INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NOT NULL,
    [PnLField]                NVARCHAR (50)  NULL,
    [finCostTypeID]           INT            NULL,
    [UnitID]                  INT            NULL,
    [prdGroup6ID]             INT            NULL,
    [sysUOMClientCode]        NVARCHAR (100) NULL,
    [sysAmount]               FLOAT (53)     CONSTRAINT [DF_tblProfitAndLossCriteria_sysAmount_1] DEFAULT ((0)) NOT NULL,
    [sysAmountDiv]            FLOAT (53)     CONSTRAINT [DF_tblProfitAndLossCriteria_sysAmountDiv_1] DEFAULT ((0)) NOT NULL,
    [netWeight]               FLOAT (53)     CONSTRAINT [DF_tblProfitAndLossCriteria_netWeight] DEFAULT ((0)) NOT NULL,
    [prdConversionFactor]     FLOAT (53)     CONSTRAINT [DF_tblProfitAndLossCriteria_prdConversionFactor] DEFAULT ((0)) NOT NULL,
    [prdConversionFactorDiv]  FLOAT (53)     CONSTRAINT [DF_tblProfitAndLossCriteria_prdConversionFactorDiv] DEFAULT ((0)) NOT NULL,
    [sqlQuery]                NVARCHAR (MAX) NULL,
    [sqlFrom]                 NVARCHAR (MAX) NULL,
    [sqlWhere]                NVARCHAR (MAX) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [PK_tblProfitAndLossCriteria] PRIMARY KEY CLUSTERED ([ProfitAndLossCriteriaID] ASC),
    CONSTRAINT [FK_tblProfitAndLossCriteria_tblCountry] FOREIGN KEY ([countryID]) REFERENCES [dbo].[tblCountry] ([countryID])
);

