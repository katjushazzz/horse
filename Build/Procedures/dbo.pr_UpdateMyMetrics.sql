SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[pr_UpdateMyMetrics] 
	@SessionClientID INT,
	@ClientID INT,
	@ProductID INT,
	@MetricKey INT,
	@UserName VARCHAR(2000),
	@MyMetricTypeCode VARCHAR(2000),
	@Action VARCHAR(25) --Expire(remove) or Add
AS 
BEGIN
/**************************************************************************************************
Project:		???
JIRA:			?
Developer:		zbachore
Date:			Feb 05 2018  02:24PM
Description:	Defines cdd.pr_UpdateMyMetrics
___________________________________________________________________________________________________
Example: EXEC dbo.pr_UpdateMyMetrics
					999999,
					100270,
					3,
					23,
				    'zbachore',
					'Hospital_MyMetric',
					'Insert'
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change

-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
DECLARE @ClientKey INT,
		@MyMetricTypeKey INT,
		@ErrorMessage VARCHAR(MAX)

BEGIN TRY
--2018 07 tran is causing error between cognos and sql server
--BEGIN TRAN;

SELECT @Clientkey = ClientKey 
FROM CommonDM.dbo.ClientDIM 
WHERE ClientID = CASE	WHEN @SessionClientID = 999999 OR  @SessionClientID = -999999
						THEN @ClientID 
						ELSE @SessionClientID END
SELECT @MyMetricTypeKey = MyMetricTypeKey 
FROM dbo.MyMetricType
WHERE MyMetricTypeCode = @MyMetricTypeCode

IF @Action = 'Insert'
   AND NOT EXISTS
(
    SELECT @ClientKey,
           @ProductID,
           @MetricKey,
           @MyMetricTypeKey,
		   @ClientID
    INTERSECT
    SELECT Clientkey,
           ProductID,
           MetricKey,
           MyMetricTypeKey,
		   ClientID
    FROM dbo.MyMetrics
)
BEGIN
    INSERT INTO dbo.MyMetrics
    (
        Clientkey,
        ProductID,
        MetricKey,
        UserName,
        MyMetricTypeKey,
		ClientID
    )
    SELECT @ClientKey,
           @ProductID,
           @MetricKey,
           @UserName,
           @MyMetricTypeKey,
		   @ClientID
		   ;

	SELECT 'SUCCESS' as ResultSet
END;

--If the row already exists, but RowIsCurrent = 0
ELSE IF @Action = 'Insert'
   AND EXISTS
(
    SELECT @ClientKey,
           @ProductID,
           @MetricKey,
           @MyMetricTypeKey,
		   @ClientID,
           0
    INTERSECT
    SELECT Clientkey,
           ProductID,
           MetricKey,
           MyMetricTypeKey,
		   ClientID,
           RowIsCurrent
    FROM dbo.MyMetrics
)
BEGIN
    UPDATE dbo.MyMetrics
    SET RowIsCurrent = 1,
        UserName = @UserName,
        UpdatedDate = DEFAULT
    WHERE Clientkey = @ClientKey
          AND ProductID = @ProductID
          AND MetricKey = @MetricKey
          AND MyMetricTypeKey = @MyMetricTypeKey;
		
		SELECT 'SUCCESS' as ResultSet
		 
END;

ELSE IF @Action = 'Insert'
   AND EXISTS
(
    SELECT @ClientKey,
           @ProductID,
           @MetricKey,
           @MyMetricTypeKey,
		   @ClientID,
           1
    INTERSECT
    SELECT Clientkey,
           ProductID,
           MetricKey,
           MyMetricTypeKey,
		   ClientID,
           RowIsCurrent
    FROM dbo.MyMetrics
)
BEGIN 
 SELECT 'SUCCESS' as ResultSet --Althogh the row already exists, we want the user to know
							  --that this is a success because the row is available to him/her.
END


ELSE IF @Action = 'Delete'
BEGIN

    UPDATE dbo.MyMetrics
    SET RowIsCurrent = 0,
        UpdatedDate = DEFAULT,
        UserName = @UserName
    WHERE Clientkey = @ClientKey
          AND ProductID = @ProductID
          AND MetricKey = @MetricKey
          AND MyMetricTypeKey = @MyMetricTypeKey
          AND RowIsCurrent = 1; --Only update if RowIsCurrent = 1
	SELECT 'SUCCESS' as ResultSet --this will also happen if the row does not exit.

END;
ELSE 
BEGIN
	SELECT 'FAILURE' as ResultSet

END


--COMMIT;
END TRY
BEGIN CATCH
    --IF ( @@TRANCOUNT > 0 )
    --        ROLLBACK TRANSACTION;
    SET @ErrorMessage ='dbo.pr_UpdateMyMetrics:' + ERROR_MESSAGE();
    THROW 50000, @ErrorMessage, 1
END CATCH;

END


GO
