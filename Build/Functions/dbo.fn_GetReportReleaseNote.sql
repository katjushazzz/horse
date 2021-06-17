SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_GetReportReleaseNote]
(
	@ReportType varchar(20),
	@TimeFrameKey INT,
	@ProductID INT
)
RETURNS VARCHAR(7500)
AS
/**************************************************************************************************
Project:		EDW2.0
JIRA:			?
Developer:		Mike Vu
Date:			2017-09-14
Description:	Get the ReleaseNote that is active as of the time provided by @TimeFrameKey
___________________________________________________________________________________________________
Example: 
SELECT dbo.fn_GetReportReleaseNote('Premier', 20160401, 3)
___________________________________________________________________________________________________
Revision History
Date			Author			Reason for Change
2017-09-11		mvu				Initial version
-------	 ------- -----------------------------------------------------------------------
***************************************************************************************************/
BEGIN
--DECLARE @ReportReleaseNote VARCHAR(7500)
--SELECT @ReportReleaseNote = ReportReleaseNote
--FROM dbo.vReportDIM
--WHERE ProductID = @ProductID
--AND @TimeFrameKey BETWEEN StartTimeframeKey AND EndTimeframeKey
--AND ReportType = @ReportType

--RETURN @ReportReleaseNote

DECLARE @ResultVar VARCHAR(7500)

--Query fetches the ReportID pertaining to the latest report revision for a give timeframecode, report type combo.

SELECT @ResultVar = CASE WHEN LTRIM(RTRIM(ISNULL(NoteHistory.ReportReleaseNote, ''))) = '' THEN '<div style="font-weight:bold; text-align: center">No Changes</div>' ELSE NoteHistory.ReportReleaseNote END
FROM CommonDM.dbo.ReportReleaseNoteHistoryDIM NoteHistory
INNER JOIN CommonDM.dbo.ReportDIM rDIM ON NoteHistory.ReportKey = rDIM.ReportKey
INNER JOIN CommonDM.dbo.ProductVersionDIM pvDIM ON rDIM.ProductVersionKey = pvDIM.ProductVersionKey
WHERE rDIM.ReportType = @ReportType 
AND pvDIM.ProductID = @ProductID 
AND @TimeFrameKey BETWEEN NoteHistory.StartTimeframeKey AND NoteHistory.EndTimeframeKey
	
-- Return the result of the function
RETURN ISNULL(@ResultVar, '<div style="font-weight:bold; text-align: center">No Changes</div>')

END


GO
