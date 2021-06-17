SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_LoadComparisonGroupSnapshotSUM_Incremental]
@ETLLogID INT,
@AggregationKey INT,
@MetricKeyList VARCHAR(8000),
@InsertCount INT OUTPUT,
@DeleteCount INT OUTPUT

AS
BEGIN
SET NOCOUNT ON;

/**************************************************************************************************
Project:		EDW2.0
JIRA:			N/A
Developer:		mvu
Date:			2019-05-07
Description:	This stored procedure is used to load the ComparisonGroupSnapshotSUM table in incremental aggregation (where 
				it runs only for certain metrics). The logic here would be delete all the previous metric rows and 
				insert new from SWITCH table.
___________________________________________________________________________________________________
Example: 
DECLARE @InsertCount INT,
		@DeleteCount INT
EXEC dbo.pr_LoadComparisonGroupSnapshotSUM_Incremental 1, 1, '1,2', @InsertCount OUTPUT, @DeleteCount OUTPUT
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2019-05-07		mvu				Created
2019-06-20		mvu				Change logic for delete, now based on AggregationKey and MetricKeyList, to make sure wiping out all metrics in the MetricKeyList.
								Previously delete was based on switch table, which wouldn't have a row for empty metrics.
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
--Variables:
DECLARE @ErrorMessage VARCHAR(2000) = ' '
BEGIN TRY
	DELETE CSS
	OUTPUT Deleted.*, @ETLLogID, NULL, GETDATE(), NULL INTO dbo.ComparisonGroupSnapshotSUM_DELETE
	FROM dbo.ComparisonGroupSnapshotSUM AS CSS
	WHERE CSS.AggregationKey = @AggregationKey AND ',' + @MetricKeyList + ',' LIKE '%,' + CAST(CSS.MetricKey AS varchar) + ',%'
	/*
	EXISTS(SELECT 1
				FROM dbo.ComparisonGroupSnapshotSUM_SWITCH AS CSS_I 
				WHERE CSS_I.AggregationKey = CSS.AggregationKey
				AND CSS_I.ComparisonGroupKey = CSS.ComparisonGroupKey
				AND CSS_I.MetricKey = CSS.MetricKey
			)
	*/
	SELECT @DeleteCount = @@ROWCOUNT

	INSERT INTO dbo.ComparisonGroupSnapshotSUM
	(
	    AggregationKey,
	    ComparisonGroupKey,
	    MetricKey,
	    ProductID,
	    R4QTimeframeKey,
	    SnpsGroupR4QNumerator,
	    SnpsGroupR4QDenominator,
	    SnpsGroupR4QPercentage,
	    SnpsGroupPctl0,
	    SnpsGroupPctl5,
	    SnpsGroupPctl10,
	    SnpsGroupPctl15,
	    SnpsGroupPctl25,
	    SnpsGroupPctl50,
	    SnpsGroupPctl75,
	    SnpsGroupPctl85,
	    SnpsGroupPctl90,
	    SnpsGroupPctl95,
	    SnpsGroupPctl100,
	    SnpsTFPctl50,
	    SnpsTFMinus1Pctl50,
	    SnpsTFMinus2Pctl50,
	    SnpsTFMinus3Pctl50
	)
	
	SELECT
	    AggregationKey,
	    ComparisonGroupKey,
	    MetricKey,
	    ProductID,
	    R4QTimeframeKey,
	    SnpsGroupR4QNumerator,
	    SnpsGroupR4QDenominator,
	    SnpsGroupR4QPercentage,
	    SnpsGroupPctl0,
	    SnpsGroupPctl5,
	    SnpsGroupPctl10,
	    SnpsGroupPctl15,
	    SnpsGroupPctl25,
	    SnpsGroupPctl50,
	    SnpsGroupPctl75,
	    SnpsGroupPctl85,
	    SnpsGroupPctl90,
	    SnpsGroupPctl95,
	    SnpsGroupPctl100,
	    SnpsTFPctl50,
	    SnpsTFMinus1Pctl50,
	    SnpsTFMinus2Pctl50,
	    SnpsTFMinus3Pctl50
	FROM dbo.ComparisonGroupSnapshotSUM_SWITCH AS CSSS
	SELECT @InsertCount=@@ROWCOUNT
	
END TRY
BEGIN CATCH
	SET @ErrorMessage = 'An error occurred in stored procedure dbo.pr_LoadComparisonGroupSnapshotSUM_Incremental: ' + ERROR_MESSAGE()
	RAISERROR (@ErrorMessage, 16 ,1);
END CATCH

SET NOCOUNT OFF;
END
GO
