SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[fn_GetAllHospitalCount]
(
    @Arg_ProductID INT,
    @Arg_TimeframeKey INT
)
RETURNS INT
AS
-- ============================================================================================
-- Author: Ramakrishna Dronavalli 
-- Create date: 12/11/2019
-- Usage: Function to fetch Count of All Hospitals for the latest published quarter required to report 
--        with Campiagn Dashboard Report
-- select ClientMetricDM.[dbo].[fn_getALLHospitalCount](2,20190101)
-- Update History:

-- ============================================================================================
BEGIN
    DECLARE @AllHospitalCount INT;
    SET @AllHospitalCount = 0;

    SELECT @AllHospitalCount = COUNT(DISTINCT cFCT.[ClientKey])
    FROM [ClientMetricDM].[dbo].[ClientFCT] cFCT
        INNER JOIN ClientMetricDM.dbo.vAggregationDIM aggDIM
            ON aggDIM.AggregationKey = cFCT.AggregationKey
               AND aggDIM.ProductID = cFCT.ProductID
    WHERE 1 = 1
          AND aggDIM.TimeframeKey = ClientMetricDM.dbo.fn_GetLatestPublishedQuarter(@Arg_TimeframeKey, @Arg_ProductID)
          AND aggDIM.ProductID = @Arg_ProductID
          AND aggDIM.RowIsCurrent = 1;

    RETURN @AllHospitalCount;

END;
GO
