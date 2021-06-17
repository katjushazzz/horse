SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_GetReportVersion](
@ReportType VARCHAR(20),
@TimeFrameKey INT,
@ProductID INT
)
RETURNS INT
AS
/**************************************************************************************************
Project:		EDW2.0
JIRA:			?
Developer:		Mike Vu
Date:			2017-09-11
Description:	Get the ReportKey that is active as of the time provided by @TimeFrameKey
___________________________________________________________________________________________________
Example: 
SELECT dbo.fn_GetReportVersion('Premier', 20160401, 3)
___________________________________________________________________________________________________
Revision History
Date			Author						Reason for Change
2017-09-11		mvu							Initial version
-------	 ------- -----------------------------------------------------------------------------------
***************************************************************************************************/
BEGIN
DECLARE @ReportKey INT

SELECT @ReportKey = ReportKey
FROM dbo.vReportDIM
WHERE ProductID = @ProductID
AND @TimeFrameKey BETWEEN StartTimeframeKey AND EndTimeframeKey
AND ReportType = @ReportType


RETURN @ReportKey
END



GO
