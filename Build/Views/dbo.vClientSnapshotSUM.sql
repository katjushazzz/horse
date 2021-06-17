SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vClientSnapshotSUM]
AS
SELECT AggregationKey
      ,MetricKey
      ,ClientKey
      ,ClientSnapshotKey
      ,ProductID
      ,R4QTimeframeKey
      ,ComparisonGroupKey
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
      ,SnpsR4QPercentile
      ,SnpsR4QConfidencePos
      ,SnpsR4QConfidenceNeg
      ,ComparisonGroupPercentile
FROM dbo.ClientSnapshotSUM
GO
