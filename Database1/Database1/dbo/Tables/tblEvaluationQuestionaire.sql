CREATE TABLE [dbo].[tblEvaluationQuestionaire] (
    [evaluationQuestionaireID] INT            IDENTITY (1, 1) NOT NULL,
    [countryID]                INT            NOT NULL,
    [questionaire]             NVARCHAR (500) NULL,
    [isActive]                 BIT            CONSTRAINT [DF_tblEvaluationQuestionaire_isActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_tblEvaluationQuestionaire] PRIMARY KEY CLUSTERED ([evaluationQuestionaireID] ASC),
    CONSTRAINT [FK_tblEvaluationQuestionaire_tblEvaluationQuestionaire] FOREIGN KEY ([countryID]) REFERENCES [dbo].[tblCountry] ([countryID])
);

