SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


/*
=================================================================================================================================================
EXEC NCDRTRNDB.NCommon.dbo.[pr_OR_NotificationEMail] 999999,@ProductId,@TimeframeCode,@EmailType,@EmailAttribute
Author:	ntafere
Date:	03/25/2020
Description: This procedure adds an OR notification queue for clients. This procedure is to be executed once standard aggregation has been published.

Example: Exec ClientMetricDM.dbo.pr_Send_OR_NotificationEmail 38, '2019Q3'

Update History:
--------------------------------------------------------------------------------------------------------------------------------------------------
Date			Author			Description
2020-06-23		zbachore		Added condition to include CPMI as part of APPSUPPORT-12052
2021-01-19		ntafere			Added AFib
--------------------------------------------------------------------------------------------------------------------------------------------------

==================================================================================================================================================

*/

CREATE PROCEDURE [dbo].[pr_Send_OR_NotificationEmail] 
	(@ProductId INT , @TimeframeCode VARCHAR(10))
AS
BEGIN

DECLARE @AggregationKey INT
		,@ClientID INT 
		,@EmailType VARCHAR(255)
		,@EmailAttribute VARCHAR(255)
		,@ErrorMessage VARCHAR(2000) = ' '

	SELECT @AggregationKey = a.AggregationKey FROM ClientMetricDM.dbo.AggregationDIM a 
		WHERE a.ProductID = @ProductId AND a.TimeFrameDisplayText = @TimeframeCode AND a.AggregationType = 'Standard Aggregation' 
		AND a.RowIsCurrent = 1 AND a.IsPublished = 1

	IF @AggregationKey IS NULL
		BEGIN
			RAISERROR ('There is no published aggregation for this Registry and Timeframe',16,1 );
			RETURN
		END


	IF @ProductId = 2 --CathPCI
	BEGIN
		SET @EmailAttribute = 'CATHPCIV4_STANDARD_REPORT_NOTIFICATION' --Review available attributes with TRN team
		SET @EmailType = 'CATHPCIV4_STANDARD_REPORT_NOTIFY_MESSAGE'
	END 

	IF @ProductId = 5 --CPMI
	BEGIN
		SET @EmailAttribute = 'ACTIONV2_OR_REPORT_NOTIFICATION'
		SET @EmailType = 'ACTIONV2_OR_REPORT_NOTIFY_MESSAGE'
	END

		IF @ProductId = 38 --AFib
	BEGIN
		SET @EmailAttribute = 'AFIBV1_STANDARD_REPORT_NOTIFICATION'
		SET @EmailType = 'NOTIFY_OUTCOMES_REPORT'
	END
	
	BEGIN TRY	
		DECLARE ClientCursor CURSOR FOR 
		SELECT DISTINCT c.ClientID FROM ClientMetricDM.dbo.ClientFCT cf
			JOIN CommonDM.dbo.ClientDIM c ON c.ClientKey = cf.ClientKey
		WHERE AggregationKey = @AggregationKey

			OPEN ClientCursor
			FETCH NEXT FROM ClientCursor INTO @ClientID
			WHILE @@FETCH_STATUS = 0
				BEGIN
				 EXEC NCDRTRNDB.NCommon.dbo.[pr_OR_NotificationEMail] @ClientID,@ProductId,@TimeframeCode,@EmailType,@EmailAttribute
				 FETCH NEXT FROM ClientCursor INTO @ClientID
				END
			CLOSE ClientCursor
		DEALLOCATE ClientCursor
	END TRY


	BEGIN CATCH
		SET @ErrorMessage = 'An error occurred in stored procedure ClientMetricDM.dbo.pr_Send_OR_NotificationEmail:' + error_message()
		RAISERROR (@ErrorMessage,16,1)
	END CATCH
END
GO
