SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vComparisonGroupSnapshotSUM]
AS
SELECT AggregationKey
      ,ComparisonGroupKey
      ,MetricKey
      ,ProductID
      ,R4QTimeframeKey
      ,SnpsGroupR4QNumerator
      ,SnpsGroupR4QDenominator
      ,SnpsGroupR4QPercentage
      ,SnpsGroupPctl0
      ,SnpsGroupPctl5
      ,SnpsGroupPctl10
      ,SnpsGroupPctl15
      ,SnpsGroupPctl25
      ,SnpsGroupPctl50
      ,SnpsGroupPctl75
      ,SnpsGroupPctl85
      ,SnpsGroupPctl90
      ,SnpsGroupPctl95
      ,SnpsGroupPctl100
      ,SnpsTFPctl50
      ,SnpsTFMinus1Pctl50
      ,SnpsTFMinus2Pctl50
      ,SnpsTFMinus3Pctl50
FROM dbo.ComparisonGroupSnapshotSUM
GO
