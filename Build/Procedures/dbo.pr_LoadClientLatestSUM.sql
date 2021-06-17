SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_LoadClientLatestSUM]
@ETLLogID INT,
@InsertCount INT OUTPUT
,@UpdateCount INT OUTPUT

AS
BEGIN
SET NOCOUNT ON;
SET XACT_ABORT ON;

/**************************************************************************************************
Project:		EDW2.0
JIRA:			N/A
Developer:		tkerlavage (Proximo)
Date:			2016-12-09
Description:	This stored procedure is used to either update or insert records in ClientLatestSUM
			Updates occur when a record for a given set of keys already exists in ClientLatestSUM
			Inserts occur when a given set of keys is not found in ClientLatestSUM
			The procedure also returns the amount of inserted and updated records in a select statement
___________________________________________________________________________________________________
Example: EXEC dbo.pr_LoadClientLatestSUM
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
12-16-2016		tkerlavage		Added transaction per JIRA: EPICDEDW-406
12-19-2016		tkerlavage		Added output parameters in order to facilitate changes required by  JIRA: EPICDEDW-406
1-12-2017		tkerlavage		Removed OUTPUT parameters from stored proc
							Insert and Update counts are now returned in simple select statements
1-13-2017		tkerlavage		Added output parameters back. Removed transaction in order to remove nested transaction
3-14-2017		mvu				Update ClientSnapshotKey in the UPDATE query
3-15-2017		mvu				Remove the "TOP 10" clause in the SELECT query
5-8-2019		mvu				Change update logic in which rows are updated only if the new aggregation timeframe is same or
								later than aggregation timeframe that updated/inserted the row last time.
04-21-2020      Madhu            added metricrollupkey in join 
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
--Variables:
DECLARE @ErrorMessage VARCHAR(2000) = ' '

BEGIN TRY

	UPDATE l
		SET Numerator=s.Numerator
		,Denominator=s.Denominator
		,Percentage=s.Percentage
		,AggregationKey=s.AggregationKey
		,ClientSnapshotKey = s.ClientSnapshotKey
	OUTPUT Deleted.*, @ETLLogID, NULL, GETDATE(), NULL INTO dbo.ClientLatestSUM_UPDATE
	FROM ClientLatestSUM_STAGE s 
	INNER JOIN ClientLatestSUM l
		ON l.ClientKey=s.ClientKey
		AND l.TimeframeKey=s.TimeframeKey
		AND l.MetricKey=s.MetricKey
		AND l.MetricRollupKey=s.MetricRollupKey
	JOIN dbo.AggregationDIM AS AD_s ON AD_s.AggregationKey = s.AggregationKey
	JOIN dbo.AggregationDIM AS AD_l ON AD_l.AggregationKey = l.AggregationKey
	WHERE AD_s.TimeframeKey >= AD_l.TimeframeKey

	SELECT @UpdateCount=@@ROWCOUNT

	INSERT INTO dbo.ClientLatestSUM_INSERT
	(
	    ClientKey,
	    TimeframeKey,
	    MetricKey,
	    ProductID,
	    Numerator,
	    Denominator,
	    Percentage,
	    AggregationKey,
	    ClientSnapshotKey,
	    ETLLogIDInsert,
	    ETLLogIDUpdate,
	    InsertTime,
	    UpdateTime,
		MetricRollupKey
	)
	SELECT 
		s.ClientKey
		,s.TimeframeKey
		,s.MetricKey
		,s.ProductID
		,s.Numerator
		,s.Denominator
		,s.Percentage
		,s.AggregationKey
		,s.ClientSnapshotKey
		,@ETLLogID AS ETLLogIDInsert
		,NULL AS ETLLogIDUpdate
		,GETDATE() AS InsertTime
		,NULL AS UpdateTime
		,s.MetricRollupKey
	FROM ClientLatestSUM_STAGE s 
	LEFT JOIN ClientLatestSUM l
		ON l.ClientKey=s.ClientKey
		AND l.TimeframeKey=s.TimeframeKey
		AND l.MetricKey=s.MetricKey
		AND l.MetricRollupKey=s.MetricRollupKey
	WHERE l.TimeframeKey IS NULL


	INSERT INTO ClientLatestSUM
	(
		ClientKey
		,TimeframeKey
		,MetricKey
		,ProductID
		,Numerator
		,Denominator
		,Percentage
		,AggregationKey
		,ClientSnapshotKey
		,MetricRollupKey
	)

	
	
SELECT
	    s.ClientKey
		,s.TimeframeKey
		,s.MetricKey
		,s.ProductID
		,s.Numerator
		,s.Denominator
		,s.Percentage
		,s.AggregationKey
		,s.ClientSnapshotKey
		,s.MetricRollupKey
	FROM dbo.ClientLatestSUM_INSERT s

		
	
	SELECT @InsertCount=@@ROWCOUNT 

	--SELECT 1/0

END TRY

BEGIN CATCH

	SET @ErrorMessage = 'An error occurred in stored procedure dbo.pr_LoadClientLatestSUM: ' + ERROR_MESSAGE()

	RAISERROR (
			@ErrorMessage
			,16
			,1
			);
END CATCH

SET NOCOUNT OFF;
END
GO
