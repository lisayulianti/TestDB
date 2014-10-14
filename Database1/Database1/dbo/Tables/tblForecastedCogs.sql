CREATE TABLE [dbo].[tblForecastedCogs] (
    [countryID]        INT        NULL,
    [productID]        INT        NULL,
    [fcgYear]          INT        NULL,
    [fcgFirstQuarter]  FLOAT (53) NULL,
    [fcgSecondQuarter] FLOAT (53) NULL,
    [fcgThirdQuarter]  FLOAT (53) NULL,
    [fcgFourthQuarter] FLOAT (53) NULL,
    [importlogID]      INT        NULL
);

