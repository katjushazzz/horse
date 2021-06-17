SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[fn_GetCohortFacilityCount]
(
    @Arg_ProductID INT,
    @Arg_TimeframeKey INT,
    @Arg_ComparisonGroupName VARCHAR(20)
)
RETURNS INT
AS
-- ============================================================================================
-- Author: Ramakrishna Dronavalli 
-- Create date: 12/11/2019
-- Usage: Function to fetch Count of Facilities for the latest published quarter 
--        with the campiagn Cohort data for the Campaign Dashboard report 
-- select ClientMetricDM.[dbo].[fn_getCohortFacilityCount](2,20190401,'PCI Bleed')
-- Update History:

-- ============================================================================================
BEGIN
    DECLARE @CohortFacilityCount INT;
    SET @CohortFacilityCount = 0;

    SELECT @CohortFacilityCount = COUNT(DISTINCT cgsDTL.ClientKey)
    FROM [ClientMetricDM].[dbo].[ComparisonGroupSnapshotDTL] cgsDTL
        INNER JOIN [ClientMetricDM].dbo.vAggregationDIM aggDIM
            ON aggDIM.AggregationKey = cgsDTL.AggregationKey
               AND aggDIM.ProductID = cgsDTL.ProductID
        INNER JOIN ClientMetricDM.dbo.vComparisonGroupDIM cgDIM
            ON cgDIM.ComparisonGroupKey = cgsDTL.ComparisonGroupKey
    WHERE aggDIM.ProductID = @Arg_ProductID 
          AND aggDIM.TimeframeKey = ClientMetricDM.dbo.fn_GetLatestPublishedQuarter(@Arg_TimeframeKey, @Arg_ProductID)
		  AND aggDIM.RowIsCurrent =1
          --AND cgsDTL.ComparisonGroupKey = 43
          AND cgDIM.ProductID = @Arg_ProductID 
          AND cgDIM.ComparisonGroupName = @Arg_ComparisonGroupName; 
    RETURN @CohortFacilityCount;

END;
GO
