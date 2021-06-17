SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vClientFCT]
AS
SELECT AggregationKey
      ,ClientKey
      ,ProductID
      ,TimeframeKey
      ,ComparisonGroupKey
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
FROM dbo.ClientFCT
GO
