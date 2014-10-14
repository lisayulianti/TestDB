CREATE TYPE [dbo].[PromoNonFinancialKPI_TableType] AS TABLE (
    [promotionID]    INT           NULL,
    [proObjectiveID] INT           NULL,
    [valueBase]      VARCHAR (MAX) NULL,
    [valuePlan]      VARCHAR (MAX) NULL,
    [valueActual]    VARCHAR (MAX) NULL);

