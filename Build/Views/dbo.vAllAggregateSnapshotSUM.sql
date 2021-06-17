SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vAllAggregateSnapshotSUM]
AS
SELECT AggregationKey
      ,MetricKey
      ,ProductID
      ,R4QTimeframeKey
      ,SnpsAllR4QNumerator
      ,SnpsAllR4QDenominator
      ,SnpsAllR4QPercentage
      ,SnpsPctl0
      ,SnpsPctl5
      ,SnpsPctl10
      ,SnpsPctl15
      ,SnpsPctl25
      ,SnpsPctl50
      ,SnpsPctl75
      ,SnpsPctl85
      ,SnpsPctl90
      ,SnpsPctl95
      ,SnpsPctl100
      ,SnpsTFPctl50
      ,SnpsTFMinus1Pctl50
      ,SnpsTFMinus2Pctl50
      ,SnpsTFMinus3Pctl50
FROM dbo.AllAggregateSnapshotSUM
GO
