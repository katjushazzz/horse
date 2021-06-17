SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[pr_ExecutiveSummaryDashboardV2]
(
    @Arg_ReportType NVARCHAR(50) = 'DASHBOARD',
    @Arg_Timeframe INT,
    @Arg_ProductId INT,
    @Arg_ParticipantID VARCHAR(10),
	@Arg_ReportSection NVARCHAR(50)
)
AS
BEGIN;

    -- =================================================================================================================
    -- Author: Ramakrishna Dronavalli
    -- Create date: July 18th 2019
    --
    -- Description:
    -- Script that fetches data for both executive summary and detail pages of the Common Detail Dashbaord
    -- First base line version implemented for CathPCI Detail Dashboard V2
    --
    -- Update History:
    --  Ramakrishna Dronavalli 09/16/2019: 
    --  Enhanced stored procedure to accomodate additional features of:
    -- 1.Dynamic metrics for a selected R4Q timeframe with a single report template (ReportKey-218)
    --	 (Driven by StartTimeframeKey and EndTimeframeKey at algorithm Level)
    -- 2. Logic that overrides percentage display to show Numerator with DenominatorNAInd Data element                
    --  Ramakrishna Dronavalli 10/01/2019: 
    --  Enhanced stored procedure to accomodate additional features of:
    -- 1. Display Headers with Detail Page of the CathPCI Detail Dashboard
    --  Ramakrishna Dronavalli 11/09/2019 (EDW-2238, EDW-2273, EDW-2026,APPSUPPORT-9836): 
    --  Enhanced stored procedure to accomodate additional features of:
    -- 1. Added data feilds of "latestPublishedR4QTFKey" and latestPublishedPublishedR4TFCode to support 
    --"Executive Summary" page of the CathPCI Detail Dashboard
    -- 2. Changed the source to "allAggSnapSum' from "aggdata" to fix the issue for "US Hospital R4Q Value" 
    -- WITH Detail Page of the Dashboard
	-- Geetha Kamepalli 02/26/2020 (DWAPI-284):
	-- Following updates have been made as part of performance tuning of the CathPCI Detail Dashboard
	-- 1. Removed data feilds of "latestPublishedR4QTFKey" and "latestPublishedPublishedR4TFCode" that support
	--"Executive Summary" page of the Detail Dashboard
	-- 2. Added @Arg_ReportSection to filter out metrics as per the Detail Dashboard dropdown selection
	--Chandrapal Nenturi 04/27/2020 (TVT Upgrade)
	--added Aggregation Type filters ( Standard 30-Day Aggregation,Realtime 30-Day Aggregation,Standard 45-Day Aggregation,Realtime 45-Day Aggregation,
	--  Standard 6-Month Aggregation,Realtime 6-Month Aggregation , Standard 1-Year Aggregation, Realtime 1-Year Aggregation', Standard 2-Year Aggregation,Realtime 2-Year Aggregation ) to support Follow-Up
	--Geetha Kamepalli 07/06/2020 (APPSUPPORT-11070)
	--Added AlgorithmCategory 'RSB' or 'RSM' condition to Current Timeframe, Timeframe-1, Timeframe-2 and Timeframe-3 group of data elements that are displayed on the 'DETAIL' section of the dashboard.
	--Added Algorithm Category to the output.
	--Geetha Kamepalli 07/30/2020 (APPSUPPORT-10017)
	--Changed the logic of US percentile data elements that are displayed on the Executive Summary view of the dashboard 
	--to not to look at MyHospital R4Q value availability
    -- =================================================================================================================
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
			   --Geetha Kamepalli added the AlgorithmCategory data item as part of APPSUPPORT-11070
			   rDTL.AlgorithmCategory
        FROM ClientMetricDM.dbo.vReportDIM rDIM
            INNER JOIN ClientMetricDM.dbo.vReportDTL rDTL
                ON rDTL.ReportKey = rDIM.ReportKey
        WHERE rDIM.ReportKey = ClientMetricDM.dbo.fn_GetReportVersion(@Arg_ReportType, @Arg_Timeframe, @Arg_ProductId)
              AND rDIM.ProductID = @Arg_ProductId
              AND rDTL.RowIsCurrent = 1
              AND rDTL.SupressRowInd = 0
              AND @Arg_Timeframe
              BETWEEN rDTL.StartTimeframeKey AND rDTL.EndTimeframeKey
			  AND rDTL.ReportSection = @Arg_ReportSection
             ),
         ClientMetricQuery
    AS (SELECT myMetrics."MetricKey" AS "MetricKey"
        FROM "ClientMetricDM"."dbo"."vMyMetrics" myMetrics
        WHERE myMetrics."ProductID" = @Arg_ProductId
              AND myMetrics."MyMetricTypeCode" = 'Hospital_MyMetric'
              AND myMetrics."ClientID" = @Arg_ParticipantID),
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
        WHERE aggDIM.TimeframeKey = ClientMetricDM.dbo.fn_GetLatestPublishedQuarter(@Arg_Timeframe, @Arg_ProductId)
              AND aggDIM.ProductID = @Arg_ProductId
			         AND
              ( 
			  ( @Arg_ReportSection IN ('EXECUTIVE SUMMARY','DETAIL','Executive Summary - Base','Detail Lines - Base') AND 
                  (aggDIM.AggregationType = 'Standard Aggregation' ))
				OR
				( @Arg_ReportSection IN ('Executive Summary - 30 Day Follow-Up','Detail Lines - 30 Day Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 30-Day Aggregation' ))
				  OR
				( @Arg_ReportSection IN ('Executive Summary - 45 Day Follow-Up','Detail Lines - 45 Day Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 45-Day Aggregation' ))
				    OR
				( @Arg_ReportSection IN ('Executive Summary - 6 Month Follow-Up','Detail Lines - 6 Month Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 6-Month Aggregation'))
				  	OR
				( @Arg_ReportSection IN ('Executive Summary - 1 Year Follow-Up','Detail Lines - 1 Year Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 1-Year Aggregation' ))
				  OR
				( @Arg_ReportSection IN ('Executive Summary - 2 Year Follow-Up','Detail Lines - 2 Year Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 2-Year Aggregation'))
              )
              AND aggDIM.RowIsCurrent = 1
              AND R4QDIM.RollingYearTimeframeKey = ClientMetricDM.dbo.fn_GetLatestPublishedQuarter(
                                                                                                      @Arg_Timeframe,
                                                                                                      @Arg_ProductId
                                                                                                  )),
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
            INNER JOIN ClientMetricDM.dbo.vAggregationDIM aggDIM
                ON aggDIM.AggregationKey = CMPSNP.AggregationKey
            INNER JOIN ClientMetricDM.dbo.vR4QTimeframeDIM R4QDIM
                ON R4QDIM.RollingYearTimeframeKey = CMPSNP.R4QTimeframeKey
        WHERE aggDIM.TimeframeKey = ClientMetricDM.dbo.fn_GetLatestPublishedQuarter(@Arg_Timeframe, @Arg_ProductId)
              AND aggDIM.ProductID = @Arg_ProductId
			  			         AND
              ( 
			  ( @Arg_ReportSection IN ('EXECUTIVE SUMMARY','DETAIL','Executive Summary - Base','Detail Lines - Base') AND 
                  (aggDIM.AggregationType = 'Standard Aggregation' ))
				OR
				( @Arg_ReportSection IN ('Executive Summary - 30 Day Follow-Up','Detail Lines - 30 Day Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 30-Day Aggregation' ))
				  OR
				( @Arg_ReportSection IN ('Executive Summary - 45 Day Follow-Up','Detail Lines - 45 Day Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 45-Day Aggregation' ))
				    OR
				( @Arg_ReportSection IN ('Executive Summary - 6 Month Follow-Up','Detail Lines - 6 Month Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 6-Month Aggregation'))
				  	OR
				( @Arg_ReportSection IN ('Executive Summary - 1 Year Follow-Up','Detail Lines - 1 Year Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 1-Year Aggregation' ))
				  OR
				( @Arg_ReportSection IN ('Executive Summary - 2 Year Follow-Up','Detail Lines - 2 Year Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 2-Year Aggregation'))
              )
              AND aggDIM.RowIsCurrent = 1
              AND R4QDIM.RollingYearTimeframeKey = ClientMetricDM.dbo.fn_GetLatestPublishedQuarter(
                                                                                                      @Arg_Timeframe,
                                                                                                      @Arg_ProductId
                                                                                                  )),
         aggData
    AS (SELECT rsSUM.ClientSnapshotKey,
               rsSUM.AggregationKey,
               rsSUM.R4QTimeframeKey,
               rsSUM.MetricKey,
               rsSUM.ClientKey,
               rsSUM.ComparisonGroupKey,
               cDIM.ClientID,
               cDIM.ClientName,
               rsSUM.SnpsAllR4QNumerator,
               rsSUM.SnpsAllR4QDenominator,
               rsSUM.SnpsAllR4QPercentage,
               rsSUM.SnpsTFNumerator,
               rsSUM.SnpsTFDenominator,
               rsSUM.SnpsTFPercentage,
               rsSUM.SnpsTFMinus1Numerator,
               rsSUM.SnpsTFMinus1Denominator,
               rsSUM.SnpsTFMinus1Percentage,
               rsSUM.SnpsTFMinus2Numerator,
               rsSUM.SnpsTFMinus2Denominator,
               rsSUM.SnpsTFMinus2Percentage,
               rsSUM.SnpsTFMinus3Numerator,
               rsSUM.SnpsTFMinus3Denominator,
               rsSUM.SnpsTFMinus3Percentage,
               rsSUM.SnpsR4QNumerator,
               rsSUM.SnpsR4QDenominator,
               rsSUM.SnpsR4QPercentage,
               rsSUM.SnpsR4QConfidencePos,
               rsSUM.SnpsR4QConfidenceNeg,
               rsSUM.SnpsR4QPercentile,
               rsSUM.SnpsGroupR4QNumerator,
               rsSUM.SnpsGroupR4QDenominator,
               rsSUM.SnpsGroupR4QPercentage,
               rsSUM.SnpsGroupPctl0,
               rsSUM.SnpsGroupPctl5,
               rsSUM.SnpsGroupPctl10,
               rsSUM.SnpsGroupPctl15,
               rsSUM.SnpsGroupPctl25,
               rsSUM.SnpsGroupPctl50,
               rsSUM.SnpsGroupPctl75,
               rsSUM.SnpsGroupPctl85,
               rsSUM.SnpsGroupPctl95,
               rsSUM.SnpsGroupPctl100,
               rsSUM.SnpsGroupTFPctl50,
               rsSUM.SnpsGroupTFMinus1Pctl50,
               rsSUM.SnpsGroupTFMinus2Pctl50,
               rsSUM.SnpsGroupTFMinus3Pctl50,
               rsSUM.AnnualizedProcVol,
               rsSUM.TFBenchmarkCode,
               rsSUM.TFPopulationCode,
               rsSUM.TFMinus1TimeframeKey,
               aggDIM.TimeFrameDisplayText,
               rsSUM.TFMinus1BenchmarkCode,
               rsSUM.TFMinus1PopulationCode,
               aggDIM.TFMinus1DisplayText,
               rsSUM.TFMinus2TimeframeKey,
               aggDIM.TFMinus2DisplayText,
               rsSUM.TFMinus2BenchmarkCode,
               rsSUM.TFMinus2PopulationCode,
               rsSUM.TFMinus3TimeframeKey,
               aggDIM.TFMinus3DisplayText,
               rsSUM.TFMinus3BenchmarkCode,
               rsSUM.TFMinus3PopulationCode
        FROM ClientMetricDM.dbo.vReportSnapshotSUM rsSUM
            INNER JOIN ClientMetricDM.dbo.vAggregationDIM aggDIM
                ON aggDIM.AggregationKey = rsSUM.AggregationKey
            INNER JOIN ClientMetricDM.dbo.vClientDIM cDIM
                ON cDIM.ClientKey = rsSUM.ClientKey
            INNER JOIN ClientMetricDM.dbo.vClientProductContract cPContract
                ON cPContract.ClientID = cDIM.ClientID
            INNER JOIN ClientMetricDM.dbo.vR4QTimeframeDIM R4QDIM
                ON R4QDIM.RollingYearTimeframeKey = rsSUM.R4QTimeframeKey
        WHERE aggDIM.TimeframeKey = @Arg_Timeframe
              AND aggDIM.ProductID = @Arg_ProductId
              AND
              ( 
			  ( @Arg_ReportSection IN ('EXECUTIVE SUMMARY','DETAIL','Executive Summary - Base','Detail Lines - Base') AND 
                  (aggDIM.AggregationType = 'Standard Aggregation'  OR aggDIM.AggregationType = 'Realtime Aggregation'))
				OR
				( @Arg_ReportSection IN ('Executive Summary - 30 Day Follow-Up','Detail Lines - 30 Day Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 30-Day Aggregation'  OR aggDIM.AggregationType = 'Realtime 30-Day Aggregation'))
				  OR
				( @Arg_ReportSection IN ('Executive Summary - 45 Day Follow-Up','Detail Lines - 45 Day Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 45-Day Aggregation'  OR aggDIM.AggregationType = 'Realtime 45-Day Aggregation'))
				    OR
				( @Arg_ReportSection IN ('Executive Summary - 6 Month Follow-Up','Detail Lines - 6 Month Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 6-Month Aggregation'  OR aggDIM.AggregationType = 'Realtime 6-Month Aggregation'))
				  	OR
				( @Arg_ReportSection IN ('Executive Summary - 1 Year Follow-Up','Detail Lines - 1 Year Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 1-Year Aggregation' OR aggDIM.AggregationType = 'Realtime 1-Year Aggregation'))
				  OR
				( @Arg_ReportSection IN ('Executive Summary - 2 Year Follow-Up','Detail Lines - 2 Year Follow-Up') AND 
                  (aggDIM.AggregationType = 'Standard 2-Year Aggregation' OR aggDIM.AggregationType = 'Realtime 2-Year Aggregation'))
              )
              AND cDIM.ClientTypeID = 1
              AND cDIM.ClientID = @Arg_ParticipantID
              AND cPContract.ProductID = @Arg_ProductId
              AND R4QDIM.RollingYearTimeframeKey = @Arg_Timeframe)
    SELECT mData.ReportKey,
           mData.MetricKey,
           cMetricData.MetricKey myMetric,
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
		   mData.AlgorithmCategory AS "Algorithm Category",
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
           allAggSnapSum.SnpsAllPctl15 AS "US Hospital 15th Percentile Value",
           allAggSnapSum.SnpsAllPctl85 AS "US Hospital 85th Percentile Value",
           allAggSnapSum.SnpsAllPctl95 AS "US Hospital 95th Percentile Value",
           allAggSnapSum.SnpsAllPctl100 AS "US Hospital 100th Percentile Value",
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
		         ROUND(allAggSnapSum.SnpsAllPctl90 * 100, mData.PercentageDecimalPrecision)
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
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                 ROUND(allAggSnapSum.SnpsAllPctl75 * 100, mData.PercentageDecimalPrecision)
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
           CASE
               WHEN
               (
                   mData.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )
                   AND mData.DenominatorNAInd = 0
               ) THEN
                 ROUND(allAggSnapSum.SnpsAllPctl50 * 100, mData.PercentageDecimalPrecision)
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
                 ROUND(allAggSnapSum.SnpsAllPctl25 * 100, mData.PercentageDecimalPrecision)
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
                 ROUND(allAggSnapSum.SnpsAllPctl10 * 100, mData.PercentageDecimalPrecision)
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
           allAggSnapSum.SnpsAllTFPctl50 AS "US Hospital Current TF 50th Percentile Value",
           allAggSnapSum.SnpsAllTFMinus1Pctl50 AS "US Hospital TF Minus1 50th Percentile Value",
           allAggSnapSum.SnpsAllTFMinus2Pctl50 AS "US Hospital TF Minus2 50th Percentile Value",
           allAggSnapSum.SnpsAllTFMinus3Pctl50 AS "US Hospital TF Minus3 50th Percentile Value",
           (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE aggData.SnpsTFNumerator END) AS "Current TF Numerator",
           (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
            THEN NULL
            ELSE aggData.SnpsTFDenominator END) AS "Current TF Denominator",
           (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
            THEN NULL
            ELSE aggData.SnpsTFPercentage END) AS "Current TF Percentage",
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
		   (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE
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
           END
           END) AS "Current TF Ratio",
		  (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE
           aggData.SnpsTFMinus1Numerator END) AS "TF Minus1 Numerator",
		   (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE
           aggData.SnpsTFMinus1Denominator END) AS "TF Minus1 Denominator",
           (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE
		   aggData.SnpsTFMinus1Percentage END) AS "TF Minus1 Percentage",
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
		   (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE
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
           END
           END) AS "TF Minus1 Ratio",
		   (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE
           aggData.SnpsTFMinus2Numerator END) AS "TF Minus2 Numerator",
           (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE
		   aggData.SnpsTFMinus2Denominator END) AS "TF Minus2 Denominator",
		   (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE
           aggData.SnpsTFMinus2Percentage END) AS "TF Minus2 Percentage",
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
		   (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE
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
           END
           END) AS "TF Minus2 Ratio",
		   (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE
           aggData.SnpsTFMinus3Numerator END) AS "TF Minus3 Numerator",
		   (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE
           aggData.SnpsTFMinus3Denominator END) AS "TF Minus3 Denominator",
		   (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE
           aggData.SnpsTFMinus3Percentage END) AS "TF Minus3 Percentage",
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
		   (CASE WHEN (mData.AlgorithmCategory like 'RSB' OR mData.AlgorithmCategory like 'RSM')
           THEN NULL
           ELSE
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
           END
           END) AS "TF Minus3 Ratio",
		   
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
           CMPGRPData.SnpsGroupPctl50 AS "Group 50th Percentile Value",
           CMPGRPData.SnpsGroupPctl75 AS "Group 75th Percentile Value",
           CMPGRPData.SnpsGroupPctl85 AS "Group 85th Percentile Value",
           CMPGRPData.SnpsGroupPctl95 AS "Group 95th Percentile Value",
           CMPGRPData.SnpsGroupPctl100 AS "Group 100th Percentile Value",
           CMPGRPData.SnpsGroupTFPctl50 AS "Group Current 50th Percentile Value",
           CMPGRPData.SnpsGroupTFMinus1Pctl50 AS "Group TF Minus1 50th Percentile Value",
           CMPGRPData.SnpsGroupTFMinus2Pctl50 AS "Group TF Minus2 50th Percentile Value",
           CMPGRPData.SnpsGroupTFMinus3Pctl50 AS "Group TF Minus3 50th Percentile Value",
           aggData.AnnualizedProcVol AS "Annualized Procedure Volume",
           aggData.TimeFrameDisplayText AS "Current Timeframe Name",
           aggData.TFBenchmarkCode AS "Current TF Benchmark Code",
           aggData.TFPopulationCode AS "Current TF Population Code",
           aggData.TFMinus1TimeframeKey AS "TF Minus1 TimeframeKey",
           aggData.TFMinus1DisplayText AS "Timeframe Minus1 Name",
           aggData.TFMinus1BenchmarkCode AS "TF Minus1 Benchmark Code",
           aggData.TFMinus1PopulationCode AS "TF Minus1 Population Code",
           aggData.TFMinus2TimeframeKey AS "TF Minus2 TimeframeKey",
           aggData.TFMinus2DisplayText AS "Timeframe Minus2 Name",
           aggData.TFMinus2BenchmarkCode AS "TF Minus2 Benchmark Code",
           aggData.TFMinus2PopulationCode AS "TF Minus2 Population Code",
           aggData.TFMinus3TimeframeKey AS "TF Minus3 TimeframeKey",
           aggData.TFMinus3DisplayText AS "Timeframe Minus3 Name",
           aggData.TFMinus3BenchmarkCode AS "TF Minus3 Benchmark Code",
           aggData.TFMinus3PopulationCode AS "TF Minus3 Population Code",
           CASE
               WHEN aggData.TFBenchmarkCode = 'G' THEN
                   '..\..\BIWebContent\images\LAAO_BMS_green_light_small.png'
               WHEN aggData.TFBenchmarkCode = 'R' THEN
                   '..\..\BIWebContent\images\LAAO_BMS_red_light_small.png'
               WHEN aggData.TFBenchmarkCode = 'Y' THEN
                   '..\..\BIWebContent\images\LAAO_BMS_yellow_light_small.png'
               WHEN aggData.TFBenchmarkCode IS NULL
                    OR aggData.TFBenchmarkCode = ' ' THEN
                   'NO'
           END AS "Image Current Time Frame",
           CASE
               WHEN aggData.TFMinus1BenchmarkCode = 'G' THEN
                   '..\..\BIWebContent\images\LAAO_BMS_green_light_small.png'
               WHEN aggData.TFMinus1BenchmarkCode = 'R' THEN
                   '..\..\BIWebContent\images\LAAO_BMS_red_light_small.png'
               WHEN aggData.TFMinus1BenchmarkCode = 'Y' THEN
                   '..\..\BIWebContent\images\LAAO_BMS_yellow_light_small.png'
               WHEN aggData.TFMinus1BenchmarkCode = ' '
                    OR aggData.TFMinus1BenchmarkCode IS NULL THEN
                   'NO'
           END AS "Image TF Minus 1",
           CASE
               WHEN aggData.TFMinus2BenchmarkCode = 'G' THEN
                   '..\..\BIWebContent\images\LAAO_BMS_green_light_small.png'
               WHEN aggData.TFMinus2BenchmarkCode = 'R' THEN
                   '..\..\BIWebContent\images\LAAO_BMS_red_light_small.png'
               WHEN aggData.TFMinus2BenchmarkCode = 'Y' THEN
                   '..\..\BIWebContent\images\LAAO_BMS_yellow_light_small.png'
               WHEN aggData.TFMinus2BenchmarkCode = ' '
                    OR aggData.TFMinus2BenchmarkCode IS NULL THEN
                   'NO'
           END AS "Image TF Minus 2",
           CASE
               WHEN aggData.TFMinus3BenchmarkCode = 'G' THEN
                   '..\..\BIWebContent\images\LAAO_BMS_green_light_small.png'
               WHEN aggData.TFMinus3BenchmarkCode = 'R' THEN
                   '..\..\BIWebContent\images\LAAO_BMS_red_light_small.png'
               WHEN aggData.TFMinus3BenchmarkCode = 'Y' THEN
                   '..\..\BIWebContent\images\LAAO_BMS_yellow_light_small.png'
               WHEN aggData.TFMinus3BenchmarkCode = ' '
                    OR aggData.TFMinus3BenchmarkCode IS NULL THEN
                   'NO'
           END AS "Image TF Minus 3"        
    FROM MetricData mData
        LEFT OUTER JOIN ClientMetricQuery cMetricData
            ON cMetricData.MetricKey = mData.MetricKey
        LEFT OUTER JOIN aggData
            ON mData.MetricKey = aggData.MetricKey
        LEFT OUTER JOIN CMPGRPData
            ON CMPGRPData.ComparisonGroupKey = aggData.ComparisonGroupKey
               AND CMPGRPData.MetricKey = aggData.MetricKey
        LEFT OUTER JOIN allAggSnapSum
            ON allAggSnapSum.MetricKey = mData.MetricKey
    ORDER BY mData.ReportSection;
END;
GO
