-- =============================================
-- Author:		Lisa Yulianti
-- Create date: 8 July 2014
-- Description:	To insert the approval route list for certain promotion
-- =============================================
CREATE PROCEDURE [dbo].[spx_InsertPromotionApproval] 
	@PromotionID int
AS
BEGIN

SET NOCOUNT ON;


-- get role of the creator for his channel/sub-channel/region (cusGroup5ID, cusGroup6ID, cusGroup2ID and secGroup2ID)
Declare @userRole nvarchar(100)
Declare @userCountry nvarchar(100)
Declare @userID int
select @userRole = tu.useRole, @userCountry = tu.countryID, @userID = prm.prmCreator --cusGroup5ID, cusGroup6ID, secGroup2ID
from tblPromotion prm 
inner join tblUser tu on tu.userID = prm.prmCreator
--inner join tblUserGroup tug on tug.userID = tu.userID 
where promotionID = @PromotionID
--and isnull(prm.cusGroup5ID,'') = isnull(tug.cusGroup5ID,'')
--and isnull(prm.cusGroup6ID,'') = isnull(tug.cusGroup6ID,'') and isnull(prm.secGroup2ID,'') = isnull(tug.secGroup2ID,'')


-- delete any approval data in tblPromoApproval (if any)
delete tblPromoApproval where promotionID = @PromotionID


-- match the role to the tblApprovalMatrix.apmOriginatorRole to get the list of approval steps
if exists (
select top 1 apmOriginatorRole from tblApprovalMatrix 
where apmApprovalStepNumber = 1 and apmApprovalStepRole = @userRole and apmOriginatorRole = @userRole and countryID = @userCountry)
AND
exists (
select top 1 promoFinancialID from tblPromoFinancial
where promotionID = @PromotionID
)
begin
	--select *
	--from tblApprovalMatrix appMat
	--where apmOriginatorRole = @userRole and countryID = @userCountry
	--order by apmApprovalStepNumber

	-- loop through all tblApprovalMatrix
	Declare @ApprovalMatrixID as int
	Declare @apmOriginatorRole as nvarchar(60)
	Declare @apmApprovalStepRole as varchar(60)
	Declare @apmApprovalStepNumber as int

	Declare @ApprovalCriteriumFieldID as int
	Declare @apcCriteriumComparisonOperator as nvarchar(2)
	Declare @apcCriteriumValue as float

	Declare @trueFlag as bit
	Declare @testCriteria as bit

	Declare @query as nvarchar(max)
	Declare @from as nvarchar(max)
	Declare @where as nvarchar(max)
	Declare @type as nvarchar(max)
	Declare @result as nvarchar(max)
	
	Declare @sqlString as nvarchar(max)
	Declare @params as nvarchar(max)

	Declare @acgGroupNumber as int

	Declare @counter as int
	Set @counter = 0
	Declare @lastNr as int


	Declare @matrix_table as table 
	(
		ApprovalMatrixID int,
		apmOriginatorRole int,
		apmApprovalStepRole int,
		apmApprovalStepNumber int,
		isCriteriaValid bit
	)
	
	DECLARE matrix_cursor CURSOR FOR
	select ApprovalMatrixID, apmOriginatorRole, apmApprovalStepRole, apmApprovalStepNumber 
	from tblApprovalMatrix appMat
	where apmOriginatorRole = @userRole and countryID = @userCountry
	order by apmApprovalStepNumber

	open matrix_cursor
	fetch NEXT from matrix_cursor into @ApprovalMatrixID, @apmOriginatorRole, @apmApprovalStepRole, @apmApprovalStepNumber 
	
	Set @lastNr = 0

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- loop through all tblApprovalCriteriaGroup and get the distinct group no
		Declare group_cursor CURSOR FOR
		select distinct cgroup.acgGroupNumber
		from tblApprovalCriteriaGroup cgroup 
		inner join tblApprovalMatrixCriterium matrixcriteria on cgroup.ApprovalCriteriaGroupID = matrixcriteria.ApprovalCriteriumID
		where ApprovalMatrixID = @ApprovalMatrixID

		Set @trueFlag = 1

		OPEN group_cursor 
		FETCH NEXT from group_cursor into @acgGroupNumber

		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- for each group, loop through all criteria
			DECLARE criteria_cursor CURSOR FOR
			select approvalCriteriumFieldID, apcCriteriumComparisonOperator, apcCriteriumValue, acgGroupNumber
			from tblApprovalCriteria criteria 
			inner join tblApprovalCriteriaGroup cgroup on cgroup.ApproverCriteriumID = criteria.ApproverCriteriumID
			inner join tblApprovalMatrixCriterium matrixcriteria on cgroup.ApprovalCriteriaGroupID = matrixcriteria.ApprovalCriteriumID
			where ApprovalMatrixID = @ApprovalMatrixID and cgroup.acgGroupNumber = @acgGroupNumber

			OPEN criteria_cursor
			FETCH NEXT FROM criteria_cursor into @ApprovalCriteriumFieldID, @apcCriteriumComparisonOperator, @apcCriteriumValue, @acgGroupNumber

			Set @trueFlag = 1

			WHILE @@FETCH_STATUS = 0 AND @trueFlag = 1
			BEGIN

				-- validate ApprovalCriteriumFieldID
				select @query = acfQuery, @from = acfFrom, @where = acfWhere, @type = acfFieldType
				from tblApprovalCriteriumField
				where approvalCriteriumFieldId = @ApprovalCriteriumFieldID
	
				set @sqlString = N'select @resultOUT = cast(' + @query + ' as nvarchar(max)) from ' + @from + ' where ' + @where + ' ' + cast (@promotionID as nvarchar(100))

				set @params = N'@ResultOUT nvarchar(max) OUTPUT'

				execute sp_executesql @sqlstring, @params, @resultOUT = @result OUTPUT;
			
				--print @sqlstring

				set @testCriteria = 1

				if @result is null
				begin
					set @trueFlag = 0
				end
				else
				begin

	--				if @type = 'float'
					begin
						set @sqlString = N'select @resultOUT = case when cast(@var1 as ' + @type + ') ' + @apcCriteriumComparisonOperator + ' cast(@var2 as ' + @type + ') then 1 else 0 end'
						set @params = N'@var1 as nvarchar(100) = ' + @result + ', @var2 as nvarchar(100) = ' + cast(@apcCriteriumValue as nvarchar(100)) + ', @resultOUT bit OUTPUT'

						execute sp_executesql @sqlstring, @params, @resultOUT = @testCriteria OUTPUT;
						--select 'dodol'
						set @trueFlag = @testCriteria
					end
				end

				select @type,@result, @trueFlag, @testCriteria,@apcCriteriumComparisonOperator, @apcCriteriumValue, @ApprovalCriteriumFieldID, @acgGroupNumber, @apmApprovalStepRole, @ApprovalMatrixID

				FETCH NEXT FROM criteria_cursor into @ApprovalCriteriumFieldID, @apcCriteriumComparisonOperator, @apcCriteriumValue, @acgGroupNumber

			END

			CLOSE criteria_cursor
			DEALLOCATE criteria_cursor

			if @trueFlag = 1
				break
		
			FETCH NEXT from group_cursor into @acgGroupNumber
		END

		if @apmApprovalStepNumber > @lastNr and @trueFlag = 1
		begin
			Set @lastNr = @apmApprovalStepNumber
			Set @counter = @Counter + 1
		end
		select @ApprovalMatrixID
		insert into @matrix_table
		values (@ApprovalMatrixID, @apmOriginatorRole, @apmApprovalStepRole, @counter, @trueFlag)

		CLOSE group_cursor
		DEALLOCATE group_cursor

		fetch NEXT from matrix_cursor into @ApprovalMatrixID, @apmOriginatorRole, @apmApprovalStepRole, @apmApprovalStepNumber
	END

	CLOSE matrix_cursor
	DEALLOCATE matrix_cursor
			
	--select * from @matrix_table

	--select * from tblPromoApproval

	insert into tblPromoApproval (countryid, promotionid, ApprovalStatusID, appRole, userID, appApprovedNr, timeStamp)
	select @userCountry, @promotionID, 0, apmApprovalStepRole, 
	case when apmApprovalStepNumber = 1 then @userID else null end, 
	apmApprovalStepNumber, getdate()
	from @matrix_table
	where isCriteriaValid = 1

end


--SELECT 1 [promoApprovalID]
--      ,2 [countryID]
--      ,3 [promotionID]
--      ,4 [ApprovalStatusID]
--      ,5 [appRole]
--      ,6 [userID]
--      ,'1' [appApprovedNr]
--      ,'456' [appApprovedNrnotes]
--      ,GETDATE() [timeStamp]
--union
--SELECT 2 [promoApprovalID]
--      ,2 [countryID]
--      ,3 [promotionID]
--      ,4 [ApprovalStatusID]
--      ,5 [appRole]
--      ,6 [userID]
--      ,'2' [appApprovedNr]
--      ,'456' [appApprovedNrnotes]
--      ,GETDATE() [timeStamp]



END



