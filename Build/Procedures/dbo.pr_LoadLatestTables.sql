SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[pr_LoadLatestTables] 
@ETLLogID INT,
@AggregationKey INT
--,@AllAggregate_InsertCount INT OUTPUT
--,@AllAggregate_UpdateCount INT OUTPUT
,@Client_InsertCount INT OUTPUT
,@Client_UpdateCount INT OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

/**************************************************************************************************
Project:		EDW2.0
JIRA:			N/A
Developer:		tkerlavage (Proximo)
Date:			2016-12-19
Description:	This stored procedure calls the stored procedures which update or insert rows
				into AllAggregateLatestSUM and ClientLatestSUM. We also set IsPublished = 1 for the
				current Aggregation in AggregationDIM if there are no failures. 
				If there are failures, the transaction is rolled back
___________________________________________________________________________________________________
Example: EXEC dbo.pr_LoadLatestTables 5
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
1-12-2017		tkerlavage		Removed OUTPUT parameters from stored procs that arecalled in this stored procedure. 
								Modified proc exec statements. Insert and Update counts are now returned in select statements. 
1-13-2017		tkerlavage		Added OUTPUT parameters back to procs called in this procedure. 
								Changed this procedure to have OUTPUT parameters as well
								Error messages weren;t being bubbled up properly to SSIS when output was done with SSIS. 
2-14-2017		mvu				Change the update on AggregationDIM for RowIsCurrent = 1. RowIsCurrent is 0 during the load to hide it from cognos.
6-14-2019		mvu				Add ETLLogID input parameter (done during Incremental aggregation development)
08-10-2020		sravikumar		DWAPF-4 - AllAggregateLatestSum is being deprecated

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
	--Variables:
	DECLARE @ErrorMessage VARCHAR(2000) = ' '

	BEGIN TRY
		BEGIN TRAN
			--sravikumar 08/10/2020 - Deprecating AllAggregateLatestSum, hence commenting out the procedure.
			/* EXEC [dbo].[pr_LoadAllAggregateLatestSUM] @ETLLogID = @ETLLogID, @InsertCount = @AllAggregate_InsertCount OUTPUT, @UpdateCount = @AllAggregate_UpdateCount OUTPUT
			*/
			EXEC [dbo].[pr_LoadClientLatestSUM] @ETLLogID = @ETLLogID, @InsertCount = @Client_InsertCount OUTPUT, @UpdateCount = @Client_UpdateCount OUTPUT

			UPDATE AggregationDIM SET RowIsCurrent = 1
			WHERE AggregationKey=@AggregationKey

		COMMIT TRAN

	END TRY


	BEGIN CATCH
		IF(@@TRANCOUNT > 0)
			ROLLBACK TRAN

		SET @ErrorMessage = 'An error occurred in stored procedure dbo.pr_LoadLatestTables: ' + ERROR_MESSAGE()

		RAISERROR (
				@ErrorMessage
				,16
				,1
				);
	END CATCH

	SET NOCOUNT OFF;
END
GO
