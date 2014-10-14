CREATE PROCEDURE [dbo].[spx_UpdateDMSSettings]	
	@countryID int,
	@cusGroup1ID varchar(50)=null,
	@setExtClaimDays int=null,
	@setSpaceBuyType varchar(250)=null,
	@setCLSpacebuy varchar(50)=null,
	@setClpromo varchar(50)=null
AS
BEGIN
	UPDATE tblDMSSettings SET 
		DMSCusGroup1IDsettings = @cusGroup1ID,
		setExtClaimDays = @setExtClaimDays,
		setSpaceBuyType = @setSpaceBuyType,
		setCLSpacebuy = @setCLSpacebuy,
		setClpromoGT = @setClpromo
	WHERE countryID = @countryID
END



