SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vAllAggregateLatestSUM]
AS
SELECT TimeframeKey
      ,MetricKey
      ,ProductID
      ,AllNumerator
      ,AllDenominator
      ,AllPercentage
      ,AggregationKey
FROM dbo.AllAggregateLatestSUM
GO
