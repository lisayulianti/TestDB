CREATE TABLE [dbo].[tblCusSelTabBackUp] (
    [countryID]                  INT           NOT NULL,
    [cstCustomerGroupField]      NVARCHAR (30) NOT NULL,
    [cstCustomerGroupClientDesc] NVARCHAR (30) NOT NULL,
    [cstFieldClientDesc1]        NVARCHAR (30) NOT NULL,
    [cstFieldClientDesc2]        NVARCHAR (30) NULL,
    [cstOrder]                   INT           NOT NULL,
    [cstLoad]                    BIT           NOT NULL,
    [importLogID]                INT           NULL
);

