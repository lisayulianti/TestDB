CREATE TABLE [dbo].[tblCountry] (
    [countryID]   INT           NOT NULL,
    [countryName] NVARCHAR (50) NULL,
    CONSTRAINT [PK_tblCountry] PRIMARY KEY CLUSTERED ([countryID] ASC)
);

