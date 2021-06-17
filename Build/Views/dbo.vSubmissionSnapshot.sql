SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vSubmissionSnapshot]
AS
SELECT ProductID
      ,AggregationKey
      ,SubmissionKey
      ,ClientKey
      ,TimeframeKey
      ,BenchmarkCode
FROM dbo.SubmissionSnapshot
GO
