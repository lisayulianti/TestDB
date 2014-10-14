CREATE TABLE [dbo].[tblPromoEvaluation] (
    [promoEvaluationID] INT        IDENTITY (1, 1) NOT NULL,
    [promotionID]       INT        NOT NULL,
    [finCostTypeID]     INT        NULL,
    [evaGSV]            FLOAT (53) NULL,
    [evaNSV]            FLOAT (53) NULL,
    [evaGP]             FLOAT (53) NULL,
    [evaROI]            FLOAT (53) NULL,
    [evaKPItwo]         FLOAT (53) NULL,
    [evaKPIthree]       FLOAT (53) NULL,
    CONSTRAINT [tblPromoEvaluation_pk] PRIMARY KEY CLUSTERED ([promoEvaluationID] ASC),
    CONSTRAINT [FK_tblPromoEvaluation_tblPromotion] FOREIGN KEY ([promotionID]) REFERENCES [dbo].[tblPromotion] ([promotionID])
);

