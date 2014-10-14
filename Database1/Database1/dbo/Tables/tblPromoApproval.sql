CREATE TABLE [dbo].[tblPromoApproval] (
    [promoApprovalID]    INT             IDENTITY (1, 1) NOT NULL,
    [countryID]          INT             NOT NULL,
    [promotionID]        INT             NULL,
    [ApprovalStatusID]   INT             NULL,
    [appRole]            INT             NULL,
    [userID]             INT             NULL,
    [appApprovedNr]      NVARCHAR (20)   NULL,
    [appApprovedNrnotes] NVARCHAR (1000) NULL,
    [timeStamp]          DATETIME        NULL,
    [isPostApproval]     BIT             CONSTRAINT [DF_tblPromoApproval_isPostApproval] DEFAULT ((0)) NULL,
    CONSTRAINT [tblPromoApproval_pk] PRIMARY KEY CLUSTERED ([promoApprovalID] ASC)
);

