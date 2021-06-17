SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[vMyMetricType] AS
SELECT 
       MyMetricTypeKey
      ,MyMetricTypeCode
      ,MyMetricTypeName
      ,CreatedDate
      ,UpdatedDate
FROM dbo.MyMetricType

GO
