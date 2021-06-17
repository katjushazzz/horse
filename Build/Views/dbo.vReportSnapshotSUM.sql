SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vReportSnapshotSUM]
AS
SELECT 
	-- Key Columns 
	ALLSNP.AggregationKey
	,ALLSNP.R4QTimeframeKey
	,ALLSNP.MetricKey
	,CF.ClientKey
	,CF.ComparisonGroupKey
	--All Hospital Snapshot Columns
	,ALLSNP.SnpsAllR4QNumerator
	,ALLSNP.SnpsAllR4QDenominator
	,ALLSNP.SnpsAllR4QPercentage
	,SnpsAllPctl0 = ALLSNP.SnpsPctl0
	,SnpsAllPctl5 = ALLSNP.SnpsPctl5
	,SnpsAllPctl10 = ALLSNP.SnpsPctl10
	,SnpsAllPctl15 = ALLSNP.SnpsPctl15
	,SnpsAllPctl25 = ALLSNP.SnpsPctl25
	,SnpsAllPctl50 = ALLSNP.SnpsPctl50
	,SnpsAllPctl75 = ALLSNP.SnpsPctl75
	,SnpsAllPctl85 = ALLSNP.SnpsPctl85
	,SnpsAllPctl90 = ALLSNP.SnpsPctl90
	,SnpsAllPctl95 = ALLSNP.SnpsPctl95
	,SnpsAllPctl100 = ALLSNP.SnpsPctl100
	,AllSnpsTFPctl50 = ALLSNP.SnpsTFPctl50
	,SnpsAllTFMinus1Pctl50 = ALLSNP.SnpsTFMinus1Pctl50
	,SnpsAllTFMinus2Pctl50 = ALLSNP.SnpsTFMinus2Pctl50
	,SnpsAllTFMinus3Pctl50 = ALLSNP.SnpsTFMinus3Pctl50
	--Client Snapshot Columns
	,SnpsTFNumerator
	,SnpsTFDenominator
	,SnpsTFPercentage
	,SnpsTFMinus1Numerator
	,SnpsTFMinus1Denominator
	,SnpsTFMinus1Percentage
	,SnpsTFMinus2Numerator
	,SnpsTFMinus2Denominator
	,SnpsTFMinus2Percentage
	,SnpsTFMinus3Numerator
	,SnpsTFMinus3Denominator
	,SnpsTFMinus3Percentage
	,SnpsR4QNumerator
	,SnpsR4QDenominator
	,SnpsR4QPercentage
	,SnpsR4QConfidencePos
	,SnpsR4QConfidenceNeg
	,SnpsR4QPercentile
	--Comparison Group Columns
	,SnpsGroupR4QNumerator
	,SnpsGroupR4QDenominator
	,SnpsGroupR4QPercentage
	,CMPSNP.SnpsGroupPctl0
	,CMPSNP.SnpsGroupPctl5
	,CMPSNP.SnpsGroupPctl10
	,CMPSNP.SnpsGroupPctl15
	,CMPSNP.SnpsGroupPctl25
	,CMPSNP.SnpsGroupPctl50
	,CMPSNP.SnpsGroupPctl75
	,CMPSNP.SnpsGroupPctl85
	,CMPSNP.SnpsGroupPctl95
	,CMPSNP.SnpsGroupPctl100
	,SnpsGroupTFPctl50 = CMPSNP.SnpsTFPctl50
	,SnpsGroupTFMinus1Pctl50 = CMPSNP.SnpsTFMinus1Pctl50
	,SnpsGroupTFMinus2Pctl50 = CMPSNP.SnpsTFMinus2Pctl50
	,SnpsGroupTFMinus3Pctl50 = CMPSNP.SnpsTFMinus3Pctl50
	--Client FCT columns
	,AnnualizedProcVol
	,TFBenchmarkCode
	,TFPopulationCode
	,TFMinus1TimeframeKey
	,TFMinus1BenchmarkCode
	,TFMinus1PopulationCode
	,TFMinus2TimeframeKey
	,TFMinus2BenchmarkCode
	,TFMinus2PopulationCode
	,TFMinus3TimeframeKey
	,TFMinus3BenchmarkCode
	,TFMinus3PopulationCode
	,CSNP.ClientSnapshotKey
	,CSNP.ProductID
FROM dbo.AllAggregateSnapshotSUM ALLSNP 
JOIN dbo.ClientFCT CF ON ALLSNP.AggregationKey = CF.AggregationKey
LEFT JOIN dbo.ClientSnapshotSUM CSNP ON
	CSNP.ClientKey  = CF.ClientKey
	AND CSNP.R4QTimeframeKey = ALLSNP.R4QTimeframeKey
	AND CSNP.MetricKey = ALLSNP.MetricKey
	AND CSNP.AggregationKey = ALLSNP.AggregationKey
LEFT JOIN dbo.ComparisonGroupSnapshotSUM CMPSNP ON
	CMPSNP.ComparisonGroupKey = CF.ComparisonGroupKey 
	AND CMPSNP.R4QTimeframeKey = ALLSNP.R4QTimeframeKey
	AND CMPSNP.MetricKey = ALLSNP.MetricKey
	AND CMPSNP.AggregationKey = ALLSNP.AggregationKey
--JOIN CommonDM.dbo.MetricDIM M ON M.MetricKey = ALLSNP.MetricKey
GO
