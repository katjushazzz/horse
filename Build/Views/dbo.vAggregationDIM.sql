SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vAggregationDIM] AS
SELECT AggregationKey
      ,ProductID
      ,AggregationDateTime
      ,TimeframeKey
      ,AsOfDateTime
      ,TimeFrameDisplayText
      ,TFMinus1TimeframeKey
      ,TFMinus1DisplayText
      ,TFMinus2TimeframeKey
      ,TFMinus2DisplayText
      ,TFMinus3TimeframeKey
      ,TFMinus3DisplayText
      ,AggregationType
      ,RowIsCurrent
      ,RowStartDate
      ,RowEndDate
      ,IsPublished
      ,IsPublicReporting
      ,IsPublishedForPublicReporting
      ,IsAvailableForPublicReporting
FROM dbo.AggregationDIM
WHERE RowIsCurrent = 1
GO
