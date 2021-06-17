SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO















CREATE PROCEDURE [dbo].[pr_CampaignDashboardV2]
(
    @Arg_ReportType NVARCHAR(50) = 'CAMPAIGN',
    @Arg_Timeframe INT,
    @Arg_ProductId INT,
    @Arg_ParticipantID VARCHAR(10)
)
AS
BEGIN;

    -- =================================================================================================================
    -- Author: Ramakrishna Dronavalli
    -- Create Date: Decenber 9th 2019
    --
    -- Description:
    -- Script that fetches data required for the Campaign Dashbaord
    -- First base line version implemented for Campaign Dashbaord with CathPCI Detail Dashboard V2
    --
    -- Update History:
    -- Ramakrishna Dronavalli 01/16/2020: https://support.acc.org/browse/EDW-3393 
    -- A new data element is added to the procedure output to support the reporting needs towards 
    -- "MyHospital R4Q Baseline" which will always be 2019Q1 data of the particpant.
    -- Ramakrishna Dronavalli 01/31/2020: 
    -- Fix for addressing issue with data element of "MyHospital R4Q Baseline Ratio" and "MyHospital R4Q Baseline Value"
    --Ramakrishna Dronavalli
    -- Fix for "Group 50th Percentile Value" and improvements to aggregated data and clean up benchmark related data
	--
	--Geetha Kamepalli 12/16/20 (APPSUPPORT-13463)
	--Added AlgorithmCategory 'RSB' or 'RSM' condition to 'Current TF Value','Current TF Numerator','Current TF Percentage', 'TF Minus1 Value','TF Minus1 Numerator','TF Minus1 Percentage','TF Minus2 Value','TF Minus2 Numerator','TF Minus2 Percentage', 'TF Minus3 Value','TF Minus3 Numerator' and 'TF Minus3 Percentage' data elements that are displayed on the dashboard.
    -- =================================================================================================================
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    DECLARE @Arg_reportKey INT
        = ClientMetricDM.dbo.fn_GetReportVersion(@Arg_ReportType, @Arg_Timeframe, @Arg_ProductId);
    DECLARE @Arg_LatestPublishedQuarter INT
        = ClientMetricDM.dbo.fn_GetLatestPublishedQuarter(@Arg_Timeframe, @Arg_ProductId);
    WITH MetricData
    AS (SELECT rDIM.ReportKey,
               rDTL.MetricKey,
               rDTL.DetailLineNum AS Line#,
               rDTL.AlgorithmKey,
               rDTL.PopulationKey,
               rDIM.ProductID,
               rDIM.ReportType,
               rDIM.ReportRevision,
               rDTL.ReportSection,
               rDTL.MajorCategory,
               rDTL.MajorCategorySortOrder,
               rDTL.MinorCategory,
               rDTL.MinorCategorySortOrder,
               rDTL.DetailLineNum,
               rDTL.LineDescription,
               rDTL.LineOrderNum,
               rDTL.LineText,
               rDTL.NumeratorDecimalPrecision,
               rDTL.PercentageDecimalPrecision,
               rDTL.CalculationType,
               rDTL.DenominatorNAInd,
               rDTL.BoldInd,
               rDTL.GrayInd,
               rDTL.IndentNum,
               rDTL.LowVolumeLimit,
               rDTL.RankOrder,
               rDTL.SupressRowInd,
               rDTL.UnitOfMeasureConceptName,
               rDTL.DrillDownInd,
			   --Geetha Kamepalli added the AlgorithmCategory data item as part of APPSUPPORT-13463
			   rDTL.AlgorithmCategory
        FROM ClientMetricDM.dbo.vReportDIM rDIM
            INNER JOIN ClientMetricDM.dbo.vReportDTL rDTL
                ON rDTL.ReportKey = rDIM.ReportKey
        WHERE rDIM.ReportKey = @Arg_reportKey
              AND rDIM.ProductID = @Arg_ProductId
              AND rDTL.RowIsCurrent = 1
              AND rDTL.SupressRowInd = 0
              AND @Arg_Timeframe
              BETWEEN rDTL.StartTimeframeKey AND rDTL.EndTimeframeKey),
         allAggSnapSum
    AS (SELECT aggDIM.[AggregationKey],
               AASSum.[MetricKey],
               aggDIM.[ProductID],
               AASSum.[R4QTimeframeKey],
               AASSum.[SnpsAllR4QNumerator],
               AASSum.[SnpsAllR4QDenominator],
               AASSum.[SnpsAllR4QPercentage],
               AASSum.[SnpsPctl0] SnpsAllPctl0,
               AASSum.[SnpsPctl5] SnpsAllPctl5,
               AASSum.[SnpsPctl10] SnpsAllPctl10,
               AASSum.[SnpsPctl15] SnpsAllPctl15,
               AASSum.[SnpsPctl25] SnpsAllPctl25,
               AASSum.[SnpsPctl50] SnpsAllPctl50,
               AASSum.[SnpsPctl75] SnpsAllPctl75,
               AASSum.[SnpsPctl85] SnpsAllPctl85,
               AASSum.[SnpsPctl90] SnpsAllPctl90,
               AASSum.[SnpsPctl95] SnpsAllPctl95,
               AASSum.[SnpsPctl100] SnpsAllPctl100,
               AASSum.[SnpsTFPctl50] SnpsAllTFPctl50,
               AASSum.[SnpsTFMinus1Pctl50] SnpsAllTFMinus1Pctl50,
               AASSum.[SnpsTFMinus2Pctl50] SnpsAllTFMinus2Pctl50,
               AASSum.[SnpsTFMinus3Pctl50] SnpsAllTFMinus3Pctl50
        FROM [ClientMetricDM].[dbo].[vAllAggregateSnapshotSUM] AASSum
            INNER JOIN ClientMetricDM.dbo.vAggregationDIM aggDIM
                ON aggDIM.AggregationKey = AASSum.AggregationKey
            INNER JOIN ClientMetricDM.dbo.vR4QTimeframeDIM R4QDIM
                ON R4QDIM.RollingYearTimeframeKey = AASSum.R4QTimeframeKey
        WHERE aggDIM.TimeframeKey = @Arg_LatestPublishedQuarter
              AND aggDIM.ProductID = @Arg_ProductId
              AND aggDIM.RowIsCurrent = 1
              AND R4QDIM.RollingYearTimeframeKey = @Arg_LatestPublishedQuarter),
         CMPGRPData
    AS (SELECT CMPSNP.AggregationKey,
               CMPSNP.ComparisonGroupKey,
               CMPSNP.MetricKey,
               CMPSNP.ProductID,
               CMPSNP.R4QTimeframeKey,
               CMPSNP.SnpsGroupR4QNumerator,
               CMPSNP.SnpsGroupR4QDenominator,
               CMPSNP.SnpsGroupR4QPercentage,
               CMPSNP.SnpsGroupPctl0,
               CMPSNP.SnpsGroupPctl5,
               CMPSNP.SnpsGroupPctl10,
               CMPSNP.SnpsGroupPctl15,
               CMPSNP.SnpsGroupPctl25,
               CMPSNP.SnpsGroupPctl50,
               CMPSNP.SnpsGroupPctl75,
               CMPSNP.SnpsGroupPctl85,
               CMPSNP.SnpsGroupPctl95,
               CMPSNP.SnpsGroupPctl100,
               CMPSNP.SnpsTFPctl50 SnpsGroupTFPctl50,
               CMPSNP.SnpsTFMinus1Pctl50 SnpsGroupTFMinus1Pctl50,
               CMPSNP.SnpsTFMinus2Pctl50 SnpsGroupTFMinus2Pctl50,
               CMPSNP.SnpsTFMinus3Pctl50 SnpsGroupTFMinus3Pctl50
        FROM ClientMetricDM.dbo.ComparisonGroupSnapshotSUM CMPSNP
            INNER JOIN ClientMetricDM.dbo.ComparisonGroupDIM cgDIM
                ON cgDIM.ComparisonGroupKey = CMPSNP.ComparisonGroupKey
                   AND cgDIM.ProductID = CMPSNP.ProductID
            INNER JOIN ClientMetricDM.dbo.vAggregationDIM aggDIM
                ON aggDIM.AggregationKey = CMPSNP.AggregationKey
            INNER JOIN ClientMetricDM.dbo.vR4QTimeframeDIM R4QDIM
                ON R4QDIM.RollingYearTimeframeKey = CMPSNP.R4QTimeframeKey
        WHERE cgDIM.ProductID = @Arg_ProductId
              AND cgDIM.ComparisonGroupName = 'PCI Bleed'
              AND aggDIM.TimeframeKey = @Arg_LatestPublishedQuarter
              AND aggDIM.ProductID = @Arg_ProductId
              AND aggDIM.RowIsCurrent = 1
              AND R4QDIM.RollingYearTimeframeKey = @Arg_LatestPublishedQuarter),
         MyHospitalR4QBaselineData
    AS (SELECT cssSUM.ClientSnapshotKey,
               cssSUM.AggregationKey,
               cssSUM.R4QTimeframeKey,
               cssSUM.MetricKey,
               cssSUM.ClientKey,
               cssSUM.ComparisonGroupKey,
               cDIM.ClientID,
               cDIM.ClientName,
               cssSUM.SnpsR4QNumerator,
               cssSUM.SnpsR4QDenominator,
               cssSUM.SnpsR4QPercentage
        FROM ClientMetricDM.dbo.vClientSnapshotSUM cssSUM
            INNER JOIN ClientMetricDM.dbo.vAggregationDIM aggDIM
                ON aggDIM.AggregationKey = cssSUM.AggregationKey
            INNER JOIN ClientMetricDM.dbo.vClientDIM cDIM
                ON cDIM.ClientKey = cssSUM.ClientKey
            INNER JOIN ClientMetricDM.dbo.vClientProductContract cPContract
                ON cPContract.ClientID = cDIM.ClientID
        WHERE aggDIM.TimeframeKey = 20190101
              AND aggDIM.ProductID = @Arg_ProductId
              AND
              (
                  aggDIM.AggregationType = 'Standard Aggregation'
                  OR aggDIM.AggregationType = 'Realtime Aggregation'
              )
              AND cDIM.ClientTypeID = 1
              AND cDIM.ClientID = @Arg_ParticipantID
              AND cPContract.ProductID = @Arg_ProductId),
         aggData
    AS (SELECT csSum.ClientSnapshotKey,
               csSum.AggregationKey,
               csSum.R4QTimeframeKey,
               csSum.MetricKey,
               csSum.ClientKey,
               csSum.ComparisonGroupKey,
               cDIM.ClientID,
               cDIM.ClientName,
               csSum.SnpsTFNumerator,
               csSum.SnpsTFDenominator,
               csSum.SnpsTFPercentage,
               csSum.SnpsTFMinus1Numerator,
               csSum.SnpsTFMinus1Denominator,
               csSum.SnpsTFMinus1Percentage,
               csSum.SnpsTFMinus2Numerator,
               csSum.SnpsTFMinus2Denominator,
               csSum.SnpsTFMinus2Percentage,
               csSum.SnpsTFMinus3Numerator,
               csSum.SnpsTFMinus3Denominator,
               csSum.SnpsTFMinus3Percentage,
               csSum.SnpsR4QNumerator,
               csSum.SnpsR4QDenominator,
               csSum.SnpsR4QPercentage,
               csSum.SnpsR4QConfidencePos,
               csSum.SnpsR4QConfidenceNeg,
               csSum.SnpsR4QPercentile
        FROM ClientMetricDM.dbo.vClientSnapshotSUM csSum
            INNER JOIN ClientMetricDM.dbo.vAggregationDIM aggDIM
                ON aggDIM.AggregationKey = csSum.AggregationKey
            INNER JOIN ClientMetricDM.dbo.vClientDIM cDIM
                ON cDIM.ClientKey = csSum.ClientKey
            INNER JOIN ClientMetricDM.dbo.vClientProductContract cPContract
                ON cPContract.ClientID = cDIM.ClientID
            INNER JOIN ClientMetricDM.dbo.vR4QTimeframeDIM R4QDIM
                ON R4QDIM.RollingYearTimeframeKey = csSum.R4QTimeframeKey
        WHERE aggDIM.TimeframeKey = @Arg_Timeframe
              AND aggDIM.ProductID = @Arg_ProductId
              AND
              (
                  aggDIM.AggregationType = 'Standard Aggregation'
                  OR aggDIM.AggregationType = 'Realtime Aggregation'
              )
              AND cDIM.ClientTypeID = 1
              AND cDIM.ClientID = @Arg_ParticipantID
              AND cPContract.ProductID = @Arg_ProductId
              AND R4QDIM.RollingYearTimeframeKey = @Arg_Timeframe)
    SELECT @Arg_ReportType AS Arg_ReportType,
           @Arg_Timeframe AS Arg_R4QTimeframe,
           @Arg_ProductId AS Arg_ProductId,
           @Arg_ParticipantID AS Arg_ParticipantID,
           mData.ReportKey,
           mData.MetricKey,
           mData.DetailLineNum AS Line#,
           mData.AlgorithmKey,
           mData.PopulationKey,
           mData.ProductID,
           mData.ReportType,
           mData.ReportRevision AS "Report Revision",
           mData.ReportSection AS "ReportSection",
           mData.MajorCategory AS "Report Section",
           mData.MajorCategory AS "Major Category",
           mData.MajorCategorySortOrder AS "Major Category Sort Order",
           mData.MinorCategory AS "Minor Category",
           mData.MinorCategorySortOrder AS "Minor Category Sort Order",
           mData.DetailLineNum AS "Detail Line Number",
           mData.LineDescription AS "Line Description",
           mData.LineOrderNum AS "Line Order Number",
           mData.LineText AS "Line Text",
           mData.NumeratorDecimalPrecision AS "Numerator Decimal Precision",
           mData.PercentageDecimalPrecision AS "Percentage Decimal Precision",
           mData.CalculationType AS "Calculation Type",
           mData.DenominatorNAInd AS "Denominator N A Indicator",
           mData.BoldInd AS "Bold Indicator",
           mData.GrayInd AS "Gray Indicator",
           mData.IndentNum AS "Indent Number",
           mData.LowVolumeLimit AS "Low Volume Limit",
           mData.RankOrder AS "Rank Order",
           mData.SupressRowInd AS "Supress Row Indicator",
           mData.UnitOfMeasureConceptName AS "Unit Of Measure Concept Name",
           mData.DrillDownInd AS "Drill Down Indicator",
           aggData.ClientSnapshotKey AS "ClientSnapshotKey",
           aggData.AggregationKey AS "AggregationKey",
           aggData.R4QTimeframeKey AS "R4QTimeframeKey",
           aggData.ClientKey AS "ClientKey",
           aggData.ComparisonGroupKey AS "ComparisonGroupKey",
           aggData.ClientID AS "Participant ID",
           aggData.ClientName AS "Participant Name",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN allAggSnapSum.SnpsAllR4QPercentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllR4QPercentage * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllR4QNumerator, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllR4QNumerator, mData.NumeratorDecimalPrecision)
                   END
           END AS "US Hospital R4Q Value", -- Used for Detail Dashboard only

           allAggSnapSum.SnpsAllR4QNumerator AS "US Hospital R4Q Numerator",
           allAggSnapSum.SnpsAllR4QDenominator AS "US Hospital R4Q Denominator",
           allAggSnapSum.SnpsAllR4QPercentage AS "US Hospital R4Q Percentage",
           allAggSnapSum.SnpsAllPctl0 AS "US Hospital 0th Percentile Value",
           allAggSnapSum.SnpsAllPctl5 AS "US Hospital 5th Percentile Value",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN aggData.SnpsR4QPercentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl10 * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl10, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl10, mData.NumeratorDecimalPrecision)
                   END
           END AS "US Hospital 10th Percentile Value",
           allAggSnapSum.SnpsAllPctl15 AS "US Hospital 15th Percentile Value",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN aggData.SnpsR4QPercentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl25 * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl25, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl25, mData.NumeratorDecimalPrecision)
                   END
           END AS "US Hospital 25th Percentile Value",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN aggData.SnpsR4QPercentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl50 * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl50, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl50, mData.NumeratorDecimalPrecision)
                   END
           END AS "US Hospital 50th Percentile Value",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN aggData.SnpsR4QPercentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl75 * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl75, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl75, mData.NumeratorDecimalPrecision)
                   END
           END AS "US Hospital 75th Percentile Value",
           allAggSnapSum.SnpsAllPctl85 AS "US Hospital 85th Percentile Value",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN aggData.SnpsR4QPercentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl90 * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl90, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(allAggSnapSum.SnpsAllPctl90, mData.NumeratorDecimalPrecision)
                   END
           END AS "US Hospital 90th Percentile Value",
           allAggSnapSum.SnpsAllPctl95 AS "US Hospital 95th Percentile Value",
           allAggSnapSum.SnpsAllPctl100 AS "US Hospital 100th Percentile Value",
           allAggSnapSum.SnpsAllTFPctl50 AS "US Hospital Current TF 50th Percentile Value",
           allAggSnapSum.SnpsAllTFMinus1Pctl50 AS "US Hospital TF Minus1 50th Percentile Value",
           allAggSnapSum.SnpsAllTFMinus2Pctl50 AS "US Hospital TF Minus2 50th Percentile Value",
           allAggSnapSum.SnpsAllTFMinus3Pctl50 AS "US Hospital TF Minus3 50th Percentile Value",
		   CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN aggData.SnpsR4QPercentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsR4QPercentage * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsR4QNumerator, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsR4QNumerator, mData.NumeratorDecimalPrecision)
                   END
           END AS "MyHospital R4Q Value",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   '('
                   + ((CAST(CAST(ROUND(aggData.SnpsR4QNumerator, mData.NumeratorDecimalPrecision) AS REAL) AS VARCHAR(20))
                       + '/'
                      ) + CAST(aggData.SnpsR4QDenominator AS VARCHAR(20)) + ')'
                     )
               WHEN mData.DenominatorNAInd = 1 THEN
                   NULL
               ELSE
                   NULL
           END AS "MyHospital R4Q Ratio",
           
		  (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM') 
			THEN NULL
		    ELSE
		    CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN aggData.SnpsTFPercentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsTFPercentage * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsTFNumerator, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsTFNumerator, mData.NumeratorDecimalPrecision)
                   END
           END
		   END) AS "Current TF Value",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   '('
                   + ((CAST(CAST(ROUND(aggData.SnpsTFNumerator, mData.NumeratorDecimalPrecision) AS REAL) AS VARCHAR(20))
                       + '/'
                      ) + CAST(aggData.SnpsTFDenominator AS VARCHAR(20)) + ')'
                     )
               WHEN mData.DenominatorNAInd = 1 THEN
                   NULL
               ELSE
                   NULL
           END AS "Current TF Ratio",
		   (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM') 
			THEN NULL ELSE aggData.SnpsTFNumerator END) AS "Current TF Numerator",
           aggData.SnpsTFDenominator AS "Current TF Denominator",
           (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM') 
			THEN NULL ELSE aggData.SnpsTFPercentage END) AS "Current TF Percentage",
           
		   (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM') 
			THEN NULL
		    ELSE
		    CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN aggData.SnpsTFMinus1Percentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsTFMinus1Percentage * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsTFMinus1Numerator, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsTFMinus1Numerator, mData.NumeratorDecimalPrecision)
                   END
           END
		   END) AS "TF Minus1 Value",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   '('
                   + ((CAST(CAST(ROUND(aggData.SnpsTFMinus1Numerator, mData.NumeratorDecimalPrecision) AS REAL) AS VARCHAR(20))
                       + '/'
                      ) + CAST(aggData.SnpsTFMinus1Denominator AS VARCHAR(20)) + ')'
                     )
               WHEN mData.DenominatorNAInd = 1 THEN
                   NULL
               ELSE
                   NULL
           END AS "TF Minus1 Ratio",
		   (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM') 
			THEN NULL ELSE aggData.SnpsTFMinus1Numerator END) AS "TF Minus1 Numerator",
           aggData.SnpsTFMinus1Denominator AS "TF Minus1 Denominator",
           (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM') 
			THEN NULL ELSE aggData.SnpsTFMinus1Percentage END) AS "TF Minus1 Percentage",
           
		  (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM') 
			THEN NULL
		    ELSE
		    CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN aggData.SnpsTFMinus2Percentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsTFMinus2Percentage * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsTFMinus2Numerator, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsTFMinus2Numerator, mData.NumeratorDecimalPrecision)
                   END
           END
		   END) AS "TF Minus2 Value",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   '('
                   + ((CAST(CAST(ROUND(aggData.SnpsTFMinus2Numerator, mData.NumeratorDecimalPrecision) AS REAL) AS VARCHAR(20))
                       + '/'
                      ) + CAST(aggData.SnpsTFMinus2Denominator AS VARCHAR(20)) + ')'
                     )
               WHEN mData.DenominatorNAInd = 1 THEN
                   NULL
               ELSE
                   NULL
           END AS "TF Minus2 Ratio",
           (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM') 
			THEN NULL ELSE aggData.SnpsTFMinus2Numerator END) AS "TF Minus2 Numerator",
           aggData.SnpsTFMinus2Denominator AS "TF Minus2 Denominator",
           (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM') 
			THEN NULL ELSE aggData.SnpsTFMinus2Percentage END) AS "TF Minus2 Percentage",
           
		  (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM') 
			THEN NULL
		    ELSE
		    CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN aggData.SnpsTFMinus3Percentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsTFMinus3Percentage * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsTFMinus3Numerator, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(aggData.SnpsTFMinus3Numerator, mData.NumeratorDecimalPrecision)
                   END
           END
		   END) AS "TF Minus3 Value",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   '('
                   + ((CAST(CAST(ROUND(aggData.SnpsTFMinus3Numerator, mData.NumeratorDecimalPrecision) AS REAL) AS VARCHAR(20))
                       + '/'
                      ) + CAST(aggData.SnpsTFMinus3Denominator AS VARCHAR(20)) + ')'
                     )
               WHEN mData.DenominatorNAInd = 1 THEN
                   NULL
               ELSE
                   NULL
           END AS "TF Minus3 Ratio",
           (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM') 
			THEN NULL ELSE aggData.SnpsTFMinus3Numerator END) AS "TF Minus3 Numerator",
           aggData.SnpsTFMinus3Denominator AS "TF Minus3 Denominator",
           (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM') 
			THEN NULL ELSE aggData.SnpsTFMinus3Percentage END) AS "TF Minus3 Percentage",
           
           aggData.SnpsR4QNumerator AS "R4Q Numerator",
           aggData.SnpsR4QDenominator AS "R4Q Denominator",
           aggData.SnpsR4QPercentage AS "R4Q Percentage",
           aggData.SnpsR4QConfidencePos AS "R4Q Confidence Pos",
           aggData.SnpsR4QConfidenceNeg AS "R4Q Confidence Neg",
           aggData.SnpsR4QPercentile AS "R4Q Percentile",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN CMPGRPData.SnpsGroupR4QPercentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(CMPGRPData.SnpsGroupR4QPercentage * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(CMPGRPData.SnpsGroupR4QNumerator, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(CMPGRPData.SnpsGroupR4QNumerator, mData.NumeratorDecimalPrecision)
                   END
           END AS "Group R4Q Value",
           CMPGRPData.SnpsGroupR4QNumerator AS "Group R4Q Numerator",
           CMPGRPData.SnpsGroupR4QDenominator AS "Group R4Q Denominator",
           CMPGRPData.SnpsGroupR4QPercentage AS "Group R4Q Percentage",
           CMPGRPData.SnpsGroupPctl0 AS "Group 0th Percentile Value",
           CMPGRPData.SnpsGroupPctl5 AS "Group 5th Percentile Value",
           CMPGRPData.SnpsGroupPctl10 AS "Group 10th Percentile Value",
           CMPGRPData.SnpsGroupPctl15 AS "Group 15th Percentile Value",
           CMPGRPData.SnpsGroupPctl25 AS "Group 25th Percentile Value",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN aggData.SnpsR4QPercentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(CMPGRPData.SnpsGroupPctl50 * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(CMPGRPData.SnpsGroupPctl50, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(CMPGRPData.SnpsGroupPctl50, mData.NumeratorDecimalPrecision)
                   END
           END AS "Group 50th Percentile Value",
           CMPGRPData.SnpsGroupPctl75 AS "Group 75th Percentile Value",
           CMPGRPData.SnpsGroupPctl85 AS "Group 85th Percentile Value",
           CMPGRPData.SnpsGroupPctl95 AS "Group 95th Percentile Value",
           CMPGRPData.SnpsGroupPctl100 AS "Group 100th Percentile Value",
           CMPGRPData.SnpsGroupTFPctl50 AS "Group Current 50th Percentile Value",
           CMPGRPData.SnpsGroupTFMinus1Pctl50 AS "Group TF Minus1 50th Percentile Value",
           CMPGRPData.SnpsGroupTFMinus2Pctl50 AS "Group TF Minus2 50th Percentile Value",
           CMPGRPData.SnpsGroupTFMinus3Pctl50 AS "Group TF Minus3 50th Percentile Value",
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   CASE
                       WHEN MyHospitalR4QBaselineData.SnpsR4QPercentage IS NULL THEN
                           NULL
                       ELSE
                           ROUND(MyHospitalR4QBaselineData.SnpsR4QPercentage * 100, mData.PercentageDecimalPrecision)
                   END
               WHEN mData.DenominatorNAInd = 1 THEN
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(MyHospitalR4QBaselineData.SnpsR4QNumerator, mData.NumeratorDecimalPrecision)
                   END
               ELSE
                   CASE
                       WHEN mData.NumeratorDecimalPrecision IS NULL THEN
                           NULL
                       ELSE
                           ROUND(MyHospitalR4QBaselineData.SnpsR4QNumerator, mData.NumeratorDecimalPrecision)
                   END
           END AS "MyHospital R4Q Baseline Value",
		   CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                   '('
                   + ((CAST(CAST(ROUND(MyHospitalR4QBaselineData.SnpsR4QNumerator, mData.NumeratorDecimalPrecision) AS REAL) AS VARCHAR(20))
                       + '/'
                      ) + CAST(MyHospitalR4QBaselineData.SnpsR4QDenominator AS VARCHAR(20)) + ')'
                     )
               WHEN mData.DenominatorNAInd = 1 THEN
                   NULL
               ELSE
                   NULL
           END AS "MyHospital R4Q Baseline Ratio",
           
           @Arg_LatestPublishedQuarter AS latestPublishedR4QTFKey,
           SUBSTRING(CAST(@Arg_LatestPublishedQuarter AS VARCHAR(8)), 1, 4)
           + CASE
                 WHEN SUBSTRING(CAST(@Arg_LatestPublishedQuarter AS VARCHAR(8)), 5, 4) = '0101' THEN
                     'Q1'
                 WHEN SUBSTRING(CAST(@Arg_LatestPublishedQuarter AS VARCHAR(8)), 5, 4) = '0401' THEN
                     'Q2'
                 WHEN SUBSTRING(CAST(@Arg_LatestPublishedQuarter AS VARCHAR(8)), 5, 4) = '0701' THEN
                     'Q3'
                 WHEN SUBSTRING(CAST(@Arg_LatestPublishedQuarter AS VARCHAR(8)), 5, 4) = '1001' THEN
                     'Q4'
             END AS latestPublishedPublishedR4TFCode
    FROM MetricData mData
        LEFT OUTER JOIN aggData
            ON mData.MetricKey = aggData.MetricKey
        LEFT OUTER JOIN MyHospitalR4QBaselineData
            ON mData.MetricKey = MyHospitalR4QBaselineData.MetricKey
        LEFT OUTER JOIN CMPGRPData
            ON CMPGRPData.MetricKey = mData.MetricKey
        LEFT OUTER JOIN allAggSnapSum
            ON allAggSnapSum.MetricKey = mData.MetricKey
    ORDER BY mData.ReportSection;
END;
GO
