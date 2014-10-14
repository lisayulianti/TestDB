CREATE TABLE [dbo].[tblPrdSelTab] (
    [countryID]                 INT           NOT NULL,
    [pstProductGroupField]      NVARCHAR (30) NOT NULL,
    [pstProductGroupClientDesc] NVARCHAR (30) NOT NULL,
    [pstFieldClientDesc1]       NVARCHAR (30) NOT NULL,
    [pstFieldClientDesc2]       NVARCHAR (30) NULL,
    [pstOrder]                  INT           NOT NULL,
    [pstLoad]                   BIT           NOT NULL,
    [importLogID]               INT           NULL
);

