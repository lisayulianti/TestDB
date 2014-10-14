CREATE TABLE [dbo].[tblSetPnL] (
    [countryID]         INT            NOT NULL,
    [pnlID]             INT            IDENTITY (1, 1) NOT NULL,
    [pnlPnlFieldName]   NVARCHAR (100) NOT NULL,
    [pnlPnlName]        NVARCHAR (100) NOT NULL,
    [pnlPnlAcrCond]     NVARCHAR (100) NULL,
    [pnlPnlAcrGL]       INT            NULL,
    [pnlPnlActCond]     NVARCHAR (100) NULL,
    [pnlPnlActGL]       INT            NULL,
    [pnlPnlDesc]        NVARCHAR (100) NULL,
    [pnlFormula]        NVARCHAR (MAX) NULL,
    [pnlInAcrLogic]     NVARCHAR (100) NOT NULL,
    [pnlInAcrSequence]  INT            NOT NULL,
    [pnlOutAcrLogic]    NVARCHAR (100) NOT NULL,
    [pnlOutAcrSequence] INT            NOT NULL,
    [pnlInActLogic]     NVARCHAR (100) NOT NULL,
    [pnlInActSequence]  INT            NOT NULL,
    [pnlOutActLogic]    NVARCHAR (100) NOT NULL,
    [pnlOutActSequence] INT            NOT NULL,
    [importLogID]       INT            NOT NULL,
    CONSTRAINT [tblSetPnL_pk] PRIMARY KEY CLUSTERED ([pnlID] ASC)
);

