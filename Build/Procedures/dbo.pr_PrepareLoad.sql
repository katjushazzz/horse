SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[pr_PrepareLoad] (
	@AggregationKey INT
	,@TimeframeKey INT
	,@ProductID INT
	,@ETLLogID INT
	,@ETLMajorTaskLogID INT
	,@IsRealtime BIT = 0
	,@AggregationTypeKey INT

	)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

/**************************************************************************************************
Project:		EDW2.0
JIRA:			N/A
Developer:		tkerlavage (Proximo)
Date:			2016-12-09
Description:	This stored procedure is used to remove old data from the SWITCH and STAGE tables.
				Additionally, if this is a standard aggregation, we deactivate the previous aggregation 
				in AggregationDIM if there was one

				If the aggregation is realtime, we remove the aggregation from the target tables by calling pr_SwitchPartition
				We also delete the aggregation from AggregationDIM

___________________________________________________________________________________________________
Example: EXEC dbo.pr_PrepareLoad 30, 3, 50, 500
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
1-9-2016		tkerlavage		Added truncate for ComparisonGroupSnapshotDTL_SWITCH
2-3-2017		tkerlavage		Changes in response to EP-ICD2.2-Aggregation-OR	EPICDOR-287
								When we are loading a standard aggregation, we now check to see if ANY agg
								for the given time frame and product id is current.
								If one is found, we deactivate it. We previously only deactivated Standard Aggs, but now we deactive ANY agg.
05-31-2019      Madhu            Added truncate for insert ,update,delete tables
08-10-2020		sravikumar		DWAPF-4 - AllAggregateLatestSum is being deprecated
11-18-2020		sravikumar		DWAPF-747 - Update the RowIsCurrent Based on Aggregationtypekey.
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
	--Variables:
	DECLARE @ErrorMessage VARCHAR(2000) = ' '

	DECLARE @CurrentDateTime DATETIME
		,@PrevAggregationKey INT
		,@CurrentAggregationType VARCHAR(30)

	BEGIN TRY
		
		--truncate stage and switch tables
		TRUNCATE TABLE AllAggregateSnapshotSUM_SWITCH
		TRUNCATE TABLE dbo.AllAggregateSnapshotSUM_DELETE
		TRUNCATE TABLE ClientFCT_SWITCH
        TRUNCATE TABLE ClientSnapshotSUM_SWITCH
		TRUNCATE TABLE dbo.ClientSnapshotSUM_DELETE
        TRUNCATE TABLE ComparisonGroupSnapshotSUM_SWITCH
		TRUNCATE TABLE dbo.ComparisonGroupSnapshotSUM_DELETE
		TRUNCATE TABLE SubmissionSnapshot_SWITCH
		--sravikumar 08/10/2020 - Deprecating AllAggregateLatestSum, hence commenting out the procedure.
		--TRUNCATE TABLE AllAggregateLatestSUM_STAGE
		--TRUNCATE TABLE dbo.AllAggregateLatestSUM_INSERT
		--TRUNCATE TABLE dbo.AllAggregateLatestSUM_UPDATE
		TRUNCATE TABLE ClientLatestSUM_STAGE
		TRUNCATE TABLE dbo.ClientLatestSUM_INSERT
		TRUNCATE TABLE dbo.ClientLatestSUM_UPDATE
		TRUNCATE TABLE ComparisonGroupSnapshotDTL_SWITCH
	    

		SELECT @CurrentDateTime = GETDATE()
			,@CurrentAggregationType = CASE 
				WHEN @IsRealtime = 1
					THEN 'Realtime Aggregation'
				ELSE 'Standard Aggregation'
				END

		-- If the aggregation is not realtime
		IF @IsRealtime = 0
		BEGIN
			UPDATE dbo.AggregationDIM
			SET RowIsCurrent = 0
				,ETLLogIDUpdate = @ETLLogID
				,UpdateTime = @CurrentDateTime
				,RowEndDate = DATEADD(s, - 1, @CurrentDateTime)
			WHERE TimeframeKey = @TimeframeKey
			AND ProductID=@ProductID
			and AggregationTypeKey=@AggregationTypeKey
			AND RowIsCurrent = 1

			--check to see if there was a previous active aggregation
			--SELECT @PrevAggregationKey = AggregationKey
			--FROM dbo.AggregationDIM
			--WHERE TimeframeKey = @TimeframeKey
			--	AND ProductID=@ProductID
			--	AND RowIsCurrent = 1
			--	--AND AggregationType = @CurrentAggregationType

			---- if there was a previous aggregation, then deactivate it
			--IF @PrevAggregationKey IS NOT NULL
			--BEGIN
			--	UPDATE dbo.AggregationDIM
			--	SET RowIsCurrent = 0
			--		,ETLLogIDUpdate = @ETLLogID
			--		,UpdateTime = @CurrentDateTime
			--		,RowEndDate = DATEADD(s, - 1, @CurrentDateTime)
			--	WHERE AggregationKey = @PrevAggregationKey
			--END
		END
		ELSE
		BEGIN
			--if this is a realtime aggregation, simply remove the old aggregation data
			EXEC [dbo].[pr_SwitchPartition] @AGGREGATIONKEY, 'ClientMetricDM', 'DBO', 'AllAggregateSnapshotSUM', 0
			EXEC [dbo].[pr_SwitchPartition] @AGGREGATIONKEY, 'ClientMetricDM', 'DBO', 'ClientFCT', 0
			EXEC [dbo].[pr_SwitchPartition] @AGGREGATIONKEY, 'ClientMetricDM', 'DBO', 'ClientSnapshotSUM', 0
			EXEC [dbo].[pr_SwitchPartition] @AGGREGATIONKEY, 'ClientMetricDM', 'DBO', 'ComparisonGroupSnapshotSUM', 0
			EXEC [dbo].[pr_SwitchPartition] @AGGREGATIONKEY, 'ClientMetricDM', 'DBO', 'SubmissionSnapshot', 0
			EXEC [dbo].[pr_SwitchPartition] @AGGREGATIONKEY, 'ClientMetricDM', 'DBO', 'ComparisonGroupSnapshotDTL', 0

			
			--delete row for this aggregation key from AggregationDIM
			--it will be reinserted by SSIS
			DELETE FROM dbo.AggregationDIM 
			WHERE AggregationKey = @AggregationKey
			AND ProductID=@ProductID
		END

	END TRY

	BEGIN CATCH
		SET @ErrorMessage = 'An error occurred in stored procedure dbo.pr_PrepareLoad: ' + ERROR_MESSAGE()

		RAISERROR (
				@ErrorMessage
				,16
				,1
				);
	END CATCH

	SET NOCOUNT OFF;

END
GO
