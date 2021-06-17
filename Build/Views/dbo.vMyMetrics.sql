SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vMyMetrics]
AS
SELECT        M.MyMetricKey, M.Clientkey, M.ProductID, M.MetricKey, M.UserName, MT.MyMetricTypeKey, MT.MyMetricTypeCode, MT.MyMetricTypeName, M.CreatedDate, M.UpdatedDate, M.ClientID
FROM            dbo.MyMetrics AS M INNER JOIN
                         dbo.MyMetricType AS MT ON M.MyMetricTypeKey = MT.MyMetricTypeKey
WHERE        (M.RowIsCurrent = 1)

GO
