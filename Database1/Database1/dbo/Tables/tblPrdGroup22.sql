CREATE TABLE [dbo].[tblPrdGroup22] (
    [prdGroup22ID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]               INT            NULL,
    [p22PrdGroup22ClientCode] NVARCHAR (100) NULL,
    [p22PrdGroup22Desc]       NVARCHAR (100) NULL,
    [importLogID]             INT            NULL,
    CONSTRAINT [tblPrdGroup22_pk] PRIMARY KEY CLUSTERED ([prdGroup22ID] ASC)
);

