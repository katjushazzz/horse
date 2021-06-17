SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



/*
Author:-Madhu 
Date:- 04-22-2020
view is created to get metrics rollup info of aggregation types on comparision group trend for idividual quaters 



*/


CREATE VIEW [dbo].[VMetricRollupDIM]
AS
SELECT  [MetricRollupKey]
      ,[Name]
      ,[Description]
  FROM [ClientMetricDM].[dbo].[MetricRollupDIM]


GO
