CREATE TABLE [dbo].[tblPromoEvaluationResult] (
    [promoEvaluationResultID]     INT            IDENTITY (1, 1) NOT NULL,
    [promotionID]                 INT            NOT NULL,
    [evaPreEvaluationNotes]       NVARCHAR (MAX) NULL,
    [evaPostEvaluationLearnings1] NVARCHAR (MAX) NULL,
    [evaPostEvaluationLearnings2] NVARCHAR (MAX) NULL,
    [evaPostEvaluationLearnings3] NVARCHAR (MAX) NULL,
    [evaConclusion]               NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_tblPromoResult] PRIMARY KEY CLUSTERED ([promoEvaluationResultID] ASC),
    CONSTRAINT [FK_tblPromoResult_tblPromotion] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[tblPromotion] ([promotionID])
);

