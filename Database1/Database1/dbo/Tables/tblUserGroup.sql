CREATE TABLE [dbo].[tblUserGroup] (
    [countryID]              INT            NOT NULL,
    [userID]                 INT            NOT NULL,
    [grpCusGroup1Desc]       NVARCHAR (100) NULL,
    [cusGroup1ID]            INT            NULL,
    [grpCusGroup5Desc]       NVARCHAR (100) NULL,
    [cusGroup5ID]            INT            NULL,
    [grpCusGroup6Desc]       NVARCHAR (100) NULL,
    [cusGroup6ID]            INT            NULL,
    [grpSecGroup2ClientCode] NVARCHAR (100) NULL,
    [secGroup2ID]            INT            NULL,
    [grpCustomerClientCode]  NVARCHAR (100) NULL,
    [customerID]             INT            NULL,
    [importLogID]            INT            NOT NULL,
    [userGroupID]            INT            IDENTITY (1, 1) NOT NULL
);

