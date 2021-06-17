SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

create FUNCTION [dbo].[fn_GetReportRevision](
@ReportType varchar(20),
@TimeFrameKey INT,
@ProductID INT
)
RETURNS VARCHAR(10)
AS
/**************************************************************************************************
Project:		EDW2.0
JIRA:			?
Developer:		Mike Vu
Date:			2017-09-11
Description:	Get the ReportKey that is active as of the time provided by @TimeFrameKey
___________________________________________________________________________________________________
Example: 
SELECT dbo.fn_GetReportRevision('Premier', 20160401, 3)
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2017-10-19		mvu				Initial version
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
BEGIN
DECLARE @ReportRevision VARCHAR(10)
SELECT @ReportRevision = CAST(ReportRevision AS VARCHAR(10))
FROM dbo.vReportDIM
WHERE ProductID = @ProductID
AND @TimeFrameKey BETWEEN StartTimeframeKey AND EndTimeframeKey
AND ReportType = @ReportType

RETURN @ReportRevision
END


GO
