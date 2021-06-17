SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[vClientLatestSUM]
AS
SELECT ClientKey
      ,TimeframeKey
      ,MetricKey
      ,ProductID
      ,Numerator
      ,Denominator
      ,Percentage
      ,AggregationKey
      ,ClientSnapshotKey
	  ,MetricRollupKey 
FROM dbo.ClientLatestSUM
GO
