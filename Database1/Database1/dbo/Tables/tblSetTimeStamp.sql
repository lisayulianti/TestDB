CREATE TABLE [dbo].[tblSetTimeStamp] (
    [timeStampID]    INT            IDENTITY (1, 1) NOT NULL,
    [countryID]      INT            NOT NULL,
    [stpTableName]   NVARCHAR (200) NOT NULL,
    [stpTableDesc]   NVARCHAR (200) NOT NULL,
    [stpTableTrans]  BIT            NOT NULL,
    [stpTableInputs] NVARCHAR (200) NULL,
    [stpSqlStamp]    DATETIME       NULL,
    [stpProfStamp]   DATETIME       NULL,
    [stpSyncStamp]   BIT            NULL,
    [stpFieldLatest] NVARCHAR (200) NULL,
    [stpSqlLatest]   INT            NULL,
    [stpProfLatest]  INT            NULL,
    [importLogID]    INT            NOT NULL,
    CONSTRAINT [tblSetTimeStamp_pk] PRIMARY KEY CLUSTERED ([timeStampID] ASC)
);

