CREATE TABLE [dbo].[tblpromotionStatus] (
    [promotionStatusID]   INT           IDENTITY (1, 1) NOT NULL,
    [psStatusDescription] NVARCHAR (50) NULL,
    [countryID]           INT           NULL,
    [importLogID]         INT           NULL,
    CONSTRAINT [tblpromotionStatus_pk] PRIMARY KEY CLUSTERED ([promotionStatusID] ASC)
);

