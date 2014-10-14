CREATE TABLE [dbo].[tblSetCombination] (
    [countryID]      INT            NOT NULL,
    [combinationID]  INT            IDENTITY (1, 1) NOT NULL,
    [comCombination] NVARCHAR (100) NOT NULL,
    [comCriteria1]   VARCHAR (10)   NULL,
    [comCriteria2]   VARCHAR (10)   NULL,
    [comCriteria3]   VARCHAR (10)   NULL,
    [comCriteria4]   VARCHAR (10)   NULL,
    [comPriority]    INT            NOT NULL,
    [importLogID]    INT            NOT NULL,
    CONSTRAINT [tblSetCombination_pk] PRIMARY KEY CLUSTERED ([combinationID] ASC)
);

