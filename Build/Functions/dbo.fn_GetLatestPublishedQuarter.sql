SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- User Defined Function

CREATE FUNCTION [dbo].[fn_GetLatestPublishedQuarter]
(
	@TimeFrameKey INT,
	@ProductID INT
)
RETURNS INT
AS
BEGIN
-- Declare the return variable here
DECLARE @ResultVar int

--Query fetches latest published quarter for a given timeframe key
SELECT @ResultVar = Max(TimeframeKey)
FROM dbo.AggregationDIM
WHERE TimeframeKey <=  @TimeFrameKey
AND IsPublished = 1 AND RowIsCurrent = 1
AND AggregationType = 'Standard Aggregation'
AND ProductID = @ProductID

--Return the result of the functino
RETURN @ResultVar
END




GO
