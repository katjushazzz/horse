SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[pr_RemoveAggregation] (
	@AggregationKey INT
	,@TimeframeKey INT
	,@ProductID INT
	,@ETLLogID INT
	,@IsRealtime BIT
	)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

/**************************************************************************************************
Project:		EDW2.0
JIRA:			N/A
Developer:		tkerlavage (Proximo)
Date:			2016-12-19
Description:	This stored procedure is used to aggregation data from the target tables
				This is used in case the SSIS package fails

___________________________________________________________________________________________________
Example: EXEC dbo.pr_RemoveAggregation 30, 50, 0
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
12-22-2016		tkerlavage		Added @IsRealtime parameter to implement some additional cleanup logic
1-9-2016		tkerlavage		Added call to remove ComparisonGroupSnapshotDTL
1-18-2016		tkerlavage		Added logic to reactivate the old Aggregation if a standard aggregation fails

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
	--Variables:
	DECLARE @ErrorMessage VARCHAR(2000) = ' '
	DECLARE @CurrentDateTime DATETIME

	BEGIN TRY
		--remove the aggregation data
		EXEC [dbo].[pr_SwitchPartition] @AGGREGATIONKEY, 'ClientMetricDM', 'DBO', 'AllAggregateSnapshotSUM', 0
		EXEC [dbo].[pr_SwitchPartition] @AGGREGATIONKEY, 'ClientMetricDM', 'DBO', 'ClientFCT', 0
		EXEC [dbo].[pr_SwitchPartition] @AGGREGATIONKEY, 'ClientMetricDM', 'DBO', 'ClientSnapshotSUM', 0
		EXEC [dbo].[pr_SwitchPartition] @AGGREGATIONKEY, 'ClientMetricDM', 'DBO', 'ComparisonGroupSnapshotSUM', 0
		EXEC [dbo].[pr_SwitchPartition] @AGGREGATIONKEY, 'ClientMetricDM', 'DBO', 'SubmissionSnapshot', 0
		EXEC [dbo].[pr_SwitchPartition] @AGGREGATIONKEY, 'ClientMetricDM', 'DBO', 'ComparisonGroupSnapshotDTL', 0

		SELECT @CurrentDateTime = GETDATE()
		
		--either updeate or delete the AggregationDim row depending on whether
		--or not this is a realtime aggregation
		IF @IsRealtime=1
		BEGIN
			UPDATE dbo.AggregationDIM
			SET RowIsCurrent=0
			,RowEndDate=@CurrentDateTime
			WHERE AggregationKey = @AggregationKey
		END
		ELSE
		BEGIN
			UPDATE dbo.AggregationDIM
			SET RowIsCurrent = 1
				,ETLLogIDUpdate = @ETLLogID
				,UpdateTime = @CurrentDateTime
				,RowEndDate = '9999-12-31'
			WHERE ProductID=@ProductID
			AND TimeframeKey=@TimeframeKey
			--only update standard aggs that were deactivated earlier  in this process flow
			AND ETLLogIDUpdate=@ETLLogID
			AND RowIsCurrent=0
			--AND AggregationType LIKE 'Standard%'--its not possible that we deactivated a previously active realtime agg

			DELETE FROM dbo.AggregationDIM WHERE AggregationKey = @AggregationKey
		END

	END TRY

	BEGIN CATCH
		SET @ErrorMessage = 'An error occurred in stored procedure dbo.pr_RemoveAggregation: ' + ERROR_MESSAGE()

		RAISERROR (
				@ErrorMessage
				,16
				,1
				);
	END CATCH

	SET NOCOUNT OFF;

END
GO
