CREATE TABLE [dbo].[tblProductParent] (
    [countryID]         INT            NULL,
    [productParentID]   INT            NOT NULL,
    [ProductParentCode] NVARCHAR (100) NULL,
    [importLogID]       INT            NULL,
    [test1] NCHAR(10) NULL, 
    [test2] NCHAR(10) NULL, 
    CONSTRAINT [PK_tblProductParent] PRIMARY KEY CLUSTERED ([productParentID] ASC)
);

