USE [Procura]
GO

/****** Object: SqlProcedure [salo].[InsertVitalsFromExternalVisitNotes] Script Date: 4/24/2015 3:29:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- ==========================================================================================
-- AUTHOR:       Jared Owens
-- CREATE DATE:  04/23/15
-- DESCRIPTION:  Add Vitals from the Visit Notes application
--
--                                         REVISIONS
--   DATE    WHO  DESCRIPTION
-- ==========================================================================================
CREATE PROCEDURE [salo].[InsertVitalsFromExternalVisitNotes]
      @VisitID varchar (14)
		,@VitalsSource varchar (30)
		,@VitalsHeight varchar (20)
		,@VitalsWeight varchar (20)
		,@VitalsResp varchar (20)
		,@VitalsTemp varchar (20)
		,@PulseApicalValue int
		,@PulseApicalSeverity varchar (30)
		,@PulseRadialValue int
		,@PulseRadialSeverity varchar (30)
		,@BPSittingLeftSystolic int
		,@BPSittingLeftDiastolic int
		,@BPSittingRightSystolic int
		,@BPSittingRightDiastolic int
		,@BPStandingLeftSystolic int
		,@BPStandingLeftDiastolic int
		,@BPStandingRightSystolic int
		,@BPStandingRightDiastolic int
		,@BPLyingLeftSystolic int
		,@BPLyingLeftDiastolic int
		,@BPLyingRightSystolic int
		,@BPLyingRightDiastolic int
		,@Comments text
		,@IntakeUser varchar (10)
		
  AS
 
-- Constants and Misc Variables based on Input
Declare @NextVitals_id int 
	,@ClientID varchar (14)
	,@VitalsDate date
	,@BranchPrefixID char(1) 
	,@VitalsType varchar (1) = 'M' 
	,@RecordStatus varchar (1) = 'A'
	,@IntakeDate DateTime = getdate ()
	,@ChangeDate DateTime = getdate ()
	,@ChangeUser varchar (10) = @IntakeUser
	,@AUX_ID varchar (255) = NULL

SET NOCOUNT ON
SET XACT_ABORT ON


BEGIN TRANSACTION 

SET @BranchPrefixID = (SELECT TOP 1
                              LEFT(BRANCH_ID, 1)
                         FROM dbo.SYSTEM)

Select @VitalsDate = CAST(VISITSTART as DATE) 
	,@ClientID = CLIENT_ID
	FROM dbo.visits 
	WHERE VISIT_ID = @VisitID

EXEC salo.pp_sys_get_next_id @tablename = 'CLTVITALS'
                               ,@numrows = 1
                               ,@next_id = @NextVitals_id OUTPUT


INSERT dbo.CLTVITALS

	([VITALS_ID]
      ,[CLIENT_ID]
      ,[VDATE]
      ,[VTYPE]
      ,[VSOURCE]
      ,[VHEIGHT]
      ,[VWEIGHT]
      ,[VRESP]
      ,[VTEMP]
      ,[PAVALUE]
      ,[PASEVERITY]
      ,[PRVALUE]
      ,[PRSEVERITY]
      ,[BPSILS]
      ,[BPSILD]
      ,[BPSIRS]
      ,[BPSIRD]
      ,[BPSTLS]
      ,[BPSTLD]
      ,[BPSTRS]
      ,[BPSTRD]
      ,[BPLYLS]
      ,[BPLYLD]
      ,[BPLYRS]
      ,[BPLYRD]
      ,[COMMENTS]
      ,[INTAKE]
      ,[INTAKEUSER]
      ,[CHGDATE]
      ,[CHGUSER]
      ,[RECSTATUS]
      ,[AUX_ID])
	  
	  SELECT @BranchPrefixID + RIGHT(REPLICATE('0', 10) + CAST(@NextVitals_id AS varchar(10)), 10) AS VITAL_ID
		,@ClientID as Client_id
		,@VitalsDate as VDATE
		,@VitalsType as VTYPE
		,@VitalsSource as VSOURCE
		,@VitalsHeight as VHEIGHT
		,@VitalsWeight as VWEIGHT
		,@VitalsResp as VRESP
		,@VitalsTemp as VTEMP
		,@PulseApicalValue as PAVALUE
		,@PulseApicalSeverity as PASEVERITY
		,@PulseRadialValue as PRVALUE
		,@PulseRadialSeverity as PRSEVERITY
		,@BPSittingLeftSystolic as BPSILS
		,@BPSittingLeftDiastolic as BPSILD
		,@BPSittingRightSystolic as BPSIRS
		,@BPSittingRightDiastolic as BPSIRD
		,@BPStandingLeftSystolic as  BPSTLS
		,@BPStandingLeftDiastolic as BPSTLD
		,@BPStandingRightSystolic as BPSTRS
		,@BPStandingRightDiastolic as BPSTRD
		,@BPLyingLeftSystolic as BPLYLS
		,@BPLyingLeftDiastolic as BPLYLD
		,@BPLyingRightSystolic as BPLYRS
		,@BPLyingRightDiastolic as BPLYRD
		,@Comments as Comments
		,@IntakeDate as INTAKE
		,@IntakeUser as CHGDATE
		,@ChangeDate as CHGDATE
		,@ChangeUser as CHGUSER
		,@RecordStatus as RECSTATUS
		,@AUX_ID as AUX_ID


COMMIT TRANSACTION

RETURN
