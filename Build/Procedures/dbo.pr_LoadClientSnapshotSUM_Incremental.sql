SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_LoadClientSnapshotSUM_Incremental]
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
Description:	This stored procedure is used to load the ClientSnapshotSUM table in incremental aggregation (where 
			it runs only for certain metrics). The logic here would be delete all the previous metric rows and 
			insert new from SWITCH table.
___________________________________________________________________________________________________
Example: 
select * from dbo.ClientSnapshotSUM_DELETE
truncate table dbo.ClientSnapshotSUM_DELETE
declare @InsertCount INT,
	@UpdateCount INT,
	@DeleteCount INT

EXEC dbo.pr_LoadClientSnapshotSUM_Incremental 1, @InsertCount, @UpdateCount, @DeleteCount

___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2019-05-07		mvu				Created
2019-06-20		mvu				Change logic for delete, now based on AggregationKey and MetricKeyList. This is to make logic similar to AllAggregateSnapshotSUM
								and ComparisonGroupSnapshotSUM
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
--Variables:
DECLARE @ErrorMessage VARCHAR(2000) = ' '

BEGIN TRY
	DELETE CSS
	OUTPUT Deleted.*, @ETLLogID, NULL, GETDATE(), NULL INTO dbo.ClientSnapshotSUM_DELETE
	FROM dbo.ClientSnapshotSUM AS CSS
	WHERE CSS.AggregationKey = @AggregationKey AND ',' + @MetricKeyList + ',' LIKE '%,' + CAST(CSS.MetricKey AS varchar) + ',%'
	/*JOIN dbo.ClientSnapshotSUM_SWITCH AS CSS_I 
		ON CSS_I.AggregationKey = CSS.AggregationKey
		AND CSS_I.ClientKey = CSS.ClientKey
		AND CSS_I.MetricKey = CSS.MetricKey
	*/
	SELECT @DeleteCount = @@ROWCOUNT
	
	SET IDENTITY_INSERT dbo.ClientSnapshotSUM ON 
	INSERT INTO dbo.ClientSnapshotSUM
	(
	    AggregationKey,
	    MetricKey,
	    ClientKey,
		ClientSnapshotKey,
	    ProductID,
	    R4QTimeframeKey,
	    ComparisonGroupKey,
	    SnpsTFNumerator,
	    SnpsTFDenominator,
	    SnpsTFPercentage,
	    SnpsTFMinus1Numerator,
	    SnpsTFMinus1Denominator,
	    SnpsTFMinus1Percentage,
	    SnpsTFMinus2Numerator,
	    SnpsTFMinus2Denominator,
	    SnpsTFMinus2Percentage,
	    SnpsTFMinus3Numerator,
	    SnpsTFMinus3Denominator,
	    SnpsTFMinus3Percentage,
	    SnpsR4QNumerator,
	    SnpsR4QDenominator,
	    SnpsR4QPercentage,
	    SnpsR4QPercentile,
	    SnpsR4QConfidencePos,
	    SnpsR4QConfidenceNeg,
	    ComparisonGroupPercentile
	)
	SELECT
	    AggregationKey,
	    MetricKey,
	    ClientKey,
	    ClientSnapshotKey,
		ProductID,
	    R4QTimeframeKey,
	    ComparisonGroupKey,
	    SnpsTFNumerator,
	    SnpsTFDenominator,
	    SnpsTFPercentage,
	    SnpsTFMinus1Numerator,
	    SnpsTFMinus1Denominator,
	    SnpsTFMinus1Percentage,
	    SnpsTFMinus2Numerator,
	    SnpsTFMinus2Denominator,
	    SnpsTFMinus2Percentage,
	    SnpsTFMinus3Numerator,
	    SnpsTFMinus3Denominator,
	    SnpsTFMinus3Percentage,
	    SnpsR4QNumerator,
	    SnpsR4QDenominator,
	    SnpsR4QPercentage,
	    SnpsR4QPercentile,
	    SnpsR4QConfidencePos,
	    SnpsR4QConfidenceNeg,
	    ComparisonGroupPercentile
	FROM dbo.ClientSnapshotSUM_SWITCH AS CSSS
	SELECT @InsertCount=@@ROWCOUNT
	SET IDENTITY_INSERT dbo.ClientSnapshotSUM OFF
--	SELECT @InsertCount AS InsertCount, @UpdateCount AS UpdateCount, @DeleteCount AS DeleteCount
END TRY
BEGIN CATCH
	SET @ErrorMessage = 'An error occurred in stored procedure dbo.pr_LoadClientSnapshotSUM_Incremental: ' + ERROR_MESSAGE()
	RAISERROR (@ErrorMessage, 16 ,1);
END CATCH

SET NOCOUNT OFF;
END
GO
