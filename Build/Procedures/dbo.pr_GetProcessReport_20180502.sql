SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



--exec [dbo].[pr_GetProcessReport] 'icd'

CREATE PROCEDURE [dbo].[pr_GetProcessReport_20180502] @Registry VARCHAR(100) = NULL AS
BEGIN 

WITH Source AS (

SELECT RegistryName = pd.ProductName, Timeframe = MAX(ad.TimeFrameDisplayText), ProcessType = ad.AggregationType, SubmissionsProcessed = COUNT(*), ProcessCompletedtime = MAX(ad.UpdateTime) 
FROM dbo.SubmissionSnapshot csm
INNER JOIN dbo.AggregationDIM ad ON ad.AggregationKey = csm.AggregationKey
INNER JOIN CommonDM.dbo.ProductDIM pd ON csm.ProductID = pd.ProductID
WHERE ad.RowIsCurrent = 1
GROUP BY pd.ProductName, ad.AggregationType

UNION ALL

SELECT RegistryName = 'Action', Timeframe = MAX(ad.TimeFrameDisplayText), ProcessType = ad.AggregationType, SubmissionsProcessed = COUNT(*), ProcessCompletedtime = MAX(ad.UpdateTime)
FROM ACTIONDMAgg.dbo.SubmissionSnapshot csm
INNER JOIN ACTIONDMAgg.dbo.AggregationDIM ad ON ad.AggregationKey = csm.AggregationKey
WHERE ad.RowIsCurrent = 1
GROUP BY ad.AggregationType


UNION ALL

SELECT RegistryName = 'IMPACT', Timeframe = MAX(ad.TimeFrameDisplayText), ProcessType = ad.AggregationType, SubmissionsProcessed = COUNT(*), ProcessCompletedtime = MAX(ad.UpdateTime) 
FROM IMPACTDMAgg.dbo.SubmissionSnapshot csm
INNER JOIN IMPACTDMAgg.dbo.AggregationDIM ad ON ad.AggregationKey = csm.AggregationKey
WHERE ad.RowIsCurrent = 1
GROUP BY ad.AggregationType


UNION ALL

SELECT RegistryName = 'LAAO', Timeframe = MAX(ad.TimeFrameDisplayText), ProcessType = ad.AggregationType, SubmissionsProcessed = COUNT(*), ProcessCompletedtime = MAX(ad.UpdateTime) 
FROM LAAODMAgg.dbo.SubmissionSnapshot csm
INNER JOIN LAAODMAgg.dbo.AggregationDIM ad ON ad.AggregationKey = csm.AggregationKey
WHERE ad.RowIsCurrent = 1
GROUP BY ad.AggregationType


UNION ALL

SELECT RegistryName = 'PVI', Timeframe = MAX(ad.TimeFrameDisplayText), ProcessType = ad.AggregationType, SubmissionsProcessed = COUNT(*), ProcessCompletedtime = MAX(ad.UpdateTime) 
FROM PVIDMAgg.dbo.SubmissionSnapshot csm
INNER JOIN PVIDMAgg.dbo.AggregationDIM ad ON ad.AggregationKey = csm.AggregationKey
WHERE ad.RowIsCurrent = 1
GROUP BY ad.AggregationType

UNION ALL 

SELECT RegistryName = 'TVT', Timeframe = MAX(ad.TimeFrameDisplayText), ProcessType = ad.AggregationType, SubmissionsProcessed = COUNT(*), ProcessCompletedtime = MAX(ad.UpdateTime) 
FROM TVTDMAgg.dbo.SubmissionSnapshot csm
INNER JOIN TVTDMAgg.dbo.AggregationDIM ad ON ad.AggregationKey = csm.AggregationKey
WHERE ad.RowIsCurrent = 1
GROUP BY ad.AggregationType
)

SELECT S.RegistryName, Timeframe = MAX(Timeframe), S.ProcessType, SubmissionsProcessed = MAX(S.SubmissionsProcessed), ProcessCompletedtime = MAX(ProcessCompletedtime)
FROM Source S 
WHERE s.RegistryName = @Registry OR @Registry IS NULL
GROUP BY S.RegistryName, S.ProcessType
ORDER BY S.RegistryName, ProcessCompletedtime DESC


END



GO
