CREATE TABLE [dbo].[tblCostType] (
    [CostTypeID] INT           IDENTITY (1, 1) NOT NULL,
    [countryID]  INT           NULL,
    [ctCostName] NVARCHAR (15) NULL,
    CONSTRAINT [tblCostType_pk] PRIMARY KEY CLUSTERED ([CostTypeID] ASC)
);

