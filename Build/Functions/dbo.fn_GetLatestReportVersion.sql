SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Geetha
-- Create date: 03/25/2018
-- Description:	Function returns the report key pertaining to the latest aggregation key for a given report type and product ID.
-- =============================================



CREATE FUNCTION [dbo].[fn_GetLatestReportVersion](
@ReportType VARCHAR(20),
@ProductID INT
)
RETURNS INT
AS

BEGIN
DECLARE @ReportKey INT
SELECT @ReportKey = ReportKey
FROM dbo.vReportDIM
WHERE ProductID = @ProductID
AND ReportType = @ReportType
AND StartTimeframeKey <= 
 (SELECT MAX(timeframekey) FROM dbo.vAggregationDIM WHERE productid = @ProductID AND RowIsCurrent = 1)
 AND 
 EndTimeframekey >= (SELECT MAX(timeframekey) FROM dbo.vAggregationDIM WHERE productid = @ProductID AND RowIsCurrent = 1)
RETURN @ReportKey
END






GO
