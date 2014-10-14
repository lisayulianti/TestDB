CREATE TABLE [dbo].[tblSetActualMatch] (
    [countryID]            INT            NOT NULL,
    [pnlID]                INT            IDENTITY (1, 1) NOT NULL,
    [acmPnlFieldName]      NVARCHAR (100) NOT NULL,
    [acmMatchPnlID]        INT            NULL,
    [acmMatchPnlFieldName] NVARCHAR (100) NULL,
    [importLogID]          INT            NOT NULL,
    CONSTRAINT [tblSetActualMatch_pk] PRIMARY KEY CLUSTERED ([pnlID] ASC)
);

