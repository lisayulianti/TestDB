CREATE TABLE [dbo].[tblClaimNoteGeneration] (
    [claimNoteID]            INT            IDENTITY (1, 1) NOT NULL,
    [countryID]              INT            NULL,
    [claimClientCode]        NVARCHAR (50)  NULL,
    [promotionID]            INT            NULL,
    [cnPromotionClientCode]  NVARCHAR (50)  NULL,
    [customerID]             INT            NULL,
    [secondaryCustomerID]    INT            NULL,
    [cnGeneralLedgerCodeBSh] INT            NULL,
    [cnStatus]               INT            NULL,
    [cnCreationDate]         DATETIME       NULL,
    [cnCreator]              NVARCHAR (100) NULL,
    CONSTRAINT [tblClaimNoteGeneration_pk] PRIMARY KEY CLUSTERED ([claimNoteID] ASC)
);

