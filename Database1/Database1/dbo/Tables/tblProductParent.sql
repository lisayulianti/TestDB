CREATE TABLE [dbo].[tblProductParent] (
    [countryID]         INT            NULL,
    [productParentID]   INT            NOT NULL,
    [ProductParentCode] NVARCHAR (100) NULL,
    [importLogID]       INT            NULL,
    CONSTRAINT [PK_tblProductParent] PRIMARY KEY CLUSTERED ([productParentID] ASC)
);

