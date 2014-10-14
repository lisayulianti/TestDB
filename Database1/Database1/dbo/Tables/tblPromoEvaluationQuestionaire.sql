CREATE TABLE [dbo].[tblPromoEvaluationQuestionaire] (
    [promoEvaluationQuestionaire] INT            IDENTITY (1, 1) NOT NULL,
    [promotionID]                 INT            NULL,
    [evaluationQuestionaireID]    INT            NOT NULL,
    [evaluationAnswer]            NVARCHAR (500) NULL,
    CONSTRAINT [PK_tblPromoEvaluationQuestionaire] PRIMARY KEY CLUSTERED ([promoEvaluationQuestionaire] ASC),
    CONSTRAINT [FK_tblPromoEvaluationQuestionaire_tblEvaluationQuestionaire] FOREIGN KEY ([evaluationQuestionaireID]) REFERENCES [dbo].[tblEvaluationQuestionaire] ([evaluationQuestionaireID]),
    CONSTRAINT [FK_tblPromoEvaluationQuestionaire_tblPromotion] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[tblPromotion] ([promotionID])
);

