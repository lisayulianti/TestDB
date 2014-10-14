CREATE TABLE [dbo].[tblUser] (
    [userID]               INT            IDENTITY (1, 1) NOT NULL,
    [countryID]            INT            NOT NULL,
    [useFullName]          NVARCHAR (100) NOT NULL,
    [useDepartment]        NVARCHAR (100) NOT NULL,
    [usePromotionCreator]  BIT            NOT NULL,
    [usePromotionApprover] BIT            NOT NULL,
    [useEmail]             VARCHAR (100)  NOT NULL,
    [usePassword]          VARCHAR (50)   NOT NULL,
    [useMasterImportApp]   BIT            NOT NULL,
    [useMasterProfitTool]  BIT            NOT NULL,
    [useMasterFinance]     BIT            NOT NULL,
    [useMasterDMS]         BIT            NOT NULL,
    [useIsActive]          BIT            NOT NULL,
    [importLogID]          INT            NOT NULL,
    [useDelegateID]        INT            NULL,
    [useRole]              INT            NULL,
    CONSTRAINT [tblUser_pk] PRIMARY KEY CLUSTERED ([userID] ASC)
);

