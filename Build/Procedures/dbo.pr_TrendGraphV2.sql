SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[pr_TrendGraphV2]
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
    -- Create date: July 24th 2019
    --
    -- Description:
    -- Script that fetches data for Trend Graph with Executive Summary page of the Common Detail Dashbaord
	-- First base line version is getting implemented for CathPCI Detail Dashbaord V2
    
	-- Update History:
	 --  Ramakrishna Dronavalli 11/09/2019 (EDW-2238, EDW-2273, EDW-2026,APPSUPPORT-9836): 
	--  Enhanced stored procedure to accomodate additional features of:
		-- 1. Added data feilds of ProductId, ReportType,R4QTimeframe to the ouput data     
		
	--Geetha Kamepalli 12/11/2019 (EDW-3031)
	--Enhanced stored procedure to accomodate metrics of SUM calculation type by adding SUM type to the case expressions   
	
	--Chandrapal Nenturi 03/17/2020 (TVT)
	-- Addedd @Arg_ReportSection  to  support TVT Report sections as part of TVT Dashboard upgrade.  
	--04/29/2020   MetricRollupKey filter added to ClientLatestSum table  
	
	--Geetha Kamepalli 06/16/2020 (APPSUPPORT-10975)
	--Added the data field 'US Hospital 50th Percentile Value' to the output by adding allAggSnapSum script and related joins in the final script.
    --Added filter on the Start and Endtimeframekeys with vReportDTL in multiple areas.    

    --Geetha Kamepalli 07/08/2020 (APPSUPPORT-11070)
	--Added AlgorithmCategory 'RSB' or 'RSM' condition to SnpsTFMinus3Percentage, SnpsTFMinus2Percentage, SnpsTFMinus1Percentage, SnpsTFPercentage and Value data elements in 
	--TrendClientSnapShot, TrendClientLatest scripts to remove data in excel export as well as in Trend data analysis chart.
	
    -- =================================================================================================================

      --Start coding sql for TrendGraph Data
    WITH TrendClientSnapShot
    AS (SELECT ClientSanpshot.ParticipantID,
               ClientSanpshot.MetricKey,
               TimeDim.TimeframeKey,
               TimeDim.TimeframeCode,
               ClientSanpshot.Value
        FROM
        (
            SELECT ClientID ParticipantID,
                   MetricKey,
                   CASE B.QuarterTF
                       WHEN 0 THEN
                           CONVERT(NVARCHAR, DATEADD(qq, 0, CONVERT(DATETIME, CONVERT(NVARCHAR, R4QTimeframeKey))), 112)
                       WHEN 1 THEN
                           CONVERT(
                                      NVARCHAR,
                                      DATEADD(qq, -1, CONVERT(DATETIME, CONVERT(NVARCHAR, R4QTimeframeKey))),
                                      112
                                  )
                       WHEN 2 THEN
                           CONVERT(
                                      NVARCHAR,
                                      DATEADD(qq, -2, CONVERT(DATETIME, CONVERT(NVARCHAR, R4QTimeframeKey))),
                                      112
                                  )
                       WHEN 3 THEN
                           CONVERT(
                                      NVARCHAR,
                                      DATEADD(qq, -3, CONVERT(DATETIME, CONVERT(NVARCHAR, R4QTimeframeKey))),
                                      112
                                  )
                   END AS Timeframe,
                   CASE B.QuarterTF
                       WHEN 0 THEN
                           SnpsTFPercentage
                       WHEN 1 THEN
                           SnpsTFMinus1Percentage
                       WHEN 2 THEN
                           SnpsTFMinus2Percentage
                       WHEN 3 THEN
                           SnpsTFMinus3Percentage
                   END AS Value
            FROM
            (
                SELECT CLIENT.ClientID,
                       1 AS Joincolumn,
                       vReportDTL.MetricKey,
                       vClientSnapshotSUM.R4QTimeframeKey,
                       vAggregationDIM.AggregationKey,
					   CASE WHEN (vReportDTL.AlgorithmCategory like 'RSB' OR vReportDTL.AlgorithmCategory like 'RSM')
					   THEN NULL
					   ELSE
                       CASE
                           WHEN vReportDTL.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'AUC', 'SUM' ) THEN
                               ROUND(SnpsTFMinus3Percentage * 100, vReportDTL.PercentageDecimalPrecision)
                           ELSE
                               ROUND(SnpsTFMinus3Numerator, vReportDTL.NumeratorDecimalPrecision)
                       END 
					   END AS SnpsTFMinus3Percentage,
					   CASE WHEN (vReportDTL.AlgorithmCategory like 'RSB' OR vReportDTL.AlgorithmCategory like 'RSM')
					   THEN NULL
					   ELSE
                       CASE
                           WHEN vReportDTL.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'AUC', 'SUM' ) THEN
                               ROUND(SnpsTFMinus2Percentage * 100, vReportDTL.PercentageDecimalPrecision)
                           ELSE
                               ROUND(SnpsTFMinus2Numerator, vReportDTL.NumeratorDecimalPrecision)
                       END 
					   END AS SnpsTFMinus2Percentage,
					   CASE WHEN (vReportDTL.AlgorithmCategory like 'RSB' OR vReportDTL.AlgorithmCategory like 'RSM')
					   THEN NULL
					   ELSE
                       CASE
                           WHEN vReportDTL.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'AUC', 'SUM' ) THEN
                               ROUND(SnpsTFMinus1Percentage * 100, vReportDTL.PercentageDecimalPrecision)
                           ELSE
                               ROUND(SnpsTFMinus1Numerator, vReportDTL.NumeratorDecimalPrecision)
                       END
                       END AS SnpsTFMinus1Percentage,
					   CASE WHEN (vReportDTL.AlgorithmCategory like 'RSB' OR vReportDTL.AlgorithmCategory like 'RSM')
					   THEN NULL
					   ELSE
                       CASE
                           WHEN vReportDTL.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'AUC', 'SUM' ) THEN
                               ROUND(SnpsTFPercentage * 100, vReportDTL.PercentageDecimalPrecision)
                           ELSE
                               ROUND(SnpsTFNumerator, vReportDTL.NumeratorDecimalPrecision)
                       END 
					   END AS SnpsTFPercentage,
                       vReportDTL.AlgorithmKey,
                       vReportDTL.PopulationKey
                FROM ClientMetricDM.dbo.vClientSnapshotSUM
                    INNER JOIN ClientMetricDM.dbo.vAggregationDIM
                        ON vClientSnapshotSUM.AggregationKey = vAggregationDIM.AggregationKey
                    INNER JOIN ClientMetricDM.dbo.vReportDTL
                        ON vClientSnapshotSUM.MetricKey = vReportDTL.MetricKey
                    INNER JOIN ClientMetricDM.dbo.vClientDIM CLIENT
                        ON CLIENT.ClientKey = vClientSnapshotSUM.ClientKey
                WHERE vAggregationDIM.TimeframeKey = @Arg_Timeframe
                      AND ClientID = @Arg_ParticipantID
                      AND vAggregationDIM.RowIsCurrent = 1
                      AND vReportDTL.ReportSection = @Arg_ReportSection
					  --Following StartTimeframekey and EndTimeframekey filter is added by Geetha kamepalli as part of APPSUPPORT-10975
					  AND @Arg_Timeframe BETWEEN vReportDTL.StartTimeframeKey AND vReportDTL.EndTimeframeKey
                     
                      AND vReportDTL.ReportKey IN
                          (
                              SELECT ClientMetricDM.dbo.fn_GetReportVersion(
                                                                               @Arg_ReportType,
                                                                               @Arg_Timeframe,
                                                                               @Arg_ProductId
                                                                           )
                          )
            ) A
                RIGHT JOIN
                (
                    SELECT Joincolumn,
                           QuarterTF
                    FROM
                    (
                        SELECT 1 AS Joincolumn,
                               0 AS QuarterTF
                        UNION
                        SELECT 1 AS Joincolumn,
                               1
                        UNION
                        SELECT 1 AS Joincolumn,
                               2
                        UNION
                        SELECT 1 AS Joincolumn,
                               3
                    ) Z
                ) B
                    ON A.Joincolumn = B.Joincolumn
        ) ClientSanpshot
            RIGHT JOIN
            (
                SELECT TimeframeKey,
                       TimeframeCode
                FROM ClientMetricDM.dbo.vQuarterlyTimeframeDIM
                WHERE CONVERT(DATETIME, CONVERT(NVARCHAR, TimeframeKey))
                BETWEEN DATEADD(qq, -3, CONVERT(DATETIME, CONVERT(NVARCHAR, @Arg_Timeframe))) AND CONVERT(
                                                                                                             DATETIME,
                                                                                                             CONVERT(
                                                                                                                        NVARCHAR,
                                                                                                                        @Arg_Timeframe
                                                                                                                    )
                                                                                                         )
            ) TimeDim
                ON ClientSanpshot.Timeframe = TimeDim.TimeframeKey),
         TrendClientLatest
    AS (SELECT ClientLatest.ParticipantID,
               ClientLatest.MetricKey,
               TimeDim.TimeframeKey,
               TimeDim.TimeframeCode,
               ClientLatest.value
        FROM
        (
            SELECT CLIENT.ClientID ParticipantID,
                   vReportDTL.MetricKey,
                   --vClientLatestSUM.MetricKey,
                   vClientLatestSUM.TimeframeKey,
				   CASE WHEN (vReportDTL.AlgorithmCategory like 'RSB' OR vReportDTL.AlgorithmCategory like 'RSM')
					   THEN NULL
					   ELSE
                   CASE
                       WHEN vReportDTL.CalculationType IN  ( 'COUNT', 'COUNTDISTINCT', 'SUM', 'AUC' )THEN
                           ROUND(Percentage * 100, vReportDTL.PercentageDecimalPrecision)
                       ELSE
                           ROUND(Numerator, vReportDTL.NumeratorDecimalPrecision)
                   END 
				   END AS value
            FROM ClientMetricDM.dbo.vClientLatestSUM
                INNER JOIN ClientMetricDM.dbo.vReportDTL
                    ON vClientLatestSUM.MetricKey = vReportDTL.MetricKey
                INNER JOIN ClientMetricDM.dbo.vClientDIM CLIENT
                    ON CLIENT.ClientKey = vClientLatestSUM.ClientKey
            WHERE CLIENT.ClientID = @Arg_ParticipantID
			      --Following StartTimeframekey and EndTimeframekey filter is added by Geetha kamepalli as part of APPSUPPORT-10975
			      AND @Arg_Timeframe BETWEEN vReportDTL.StartTimeframeKey AND vReportDTL.EndTimeframeKey
                  AND ReportKey IN
                      (
                          SELECT ClientMetricDM.dbo.fn_GetReportVersion(@Arg_ReportType, @Arg_Timeframe, @Arg_ProductId)
                      )
                  AND ReportSection = @Arg_ReportSection
				  AND (
				  ( @Arg_ReportSection in ('Executive Summary - Base','EXECUTIVE SUMMARY') and vClientLatestSUM.MetricRollupKey =1)
				  OR
				  ( @Arg_ReportSection = 'Executive Summary - 30 Day Follow-Up' and vClientLatestSUM.MetricRollupKey =2)
				  OR
				  ( @Arg_ReportSection = 'Executive Summary - 45 Day Follow-Up' and vClientLatestSUM.MetricRollupKey =3)
				  OR
				  ( @Arg_ReportSection = 'Executive Summary - 6 Month Follow-Up' and vClientLatestSUM.MetricRollupKey =4)
				  OR
				  ( @Arg_ReportSection = 'Executive Summary - 1 Year Follow-Up' and vClientLatestSUM.MetricRollupKey =5)
				  OR
				  ( @Arg_ReportSection = 'Executive Summary - 2 Year Follow-Up' and vClientLatestSUM.MetricRollupKey =6)
				  )
                  AND CONVERT(DATETIME, CONVERT(NVARCHAR, vClientLatestSUM.TimeframeKey))
                  BETWEEN DATEADD(qq, -7, CONVERT(DATETIME, CONVERT(NVARCHAR, @Arg_Timeframe))) AND DATEADD(
                                                                                                               qq,
                                                                                                               -4,
                                                                                                               CONVERT(
                                                                                                                          DATETIME,
                                                                                                                          CONVERT(
                                                                                                                                     NVARCHAR,
                                                                                                                                     @Arg_Timeframe
                                                                                                                                 )
                                                                                                                      )
                                                                                                           )
        ) ClientLatest
            RIGHT JOIN
            (
                SELECT TimeframeKey,
                       TimeframeCode
                FROM ClientMetricDM.dbo.vQuarterlyTimeframeDIM
                WHERE CONVERT(DATETIME, CONVERT(NVARCHAR, TimeframeKey))
                BETWEEN DATEADD(qq, -7, CONVERT(DATETIME, CONVERT(NVARCHAR, @Arg_Timeframe))) AND DATEADD(
                                                                                                             qq,
                                                                                                             -4,
                                                                                                             CONVERT(
                                                                                                                        DATETIME,
                                                                                                                        CONVERT(
                                                                                                                                   NVARCHAR,
                                                                                                                                   @Arg_Timeframe
                                                                                                                               )
                                                                                                                    )
                                                                                                         )
            ) TimeDim
                ON TimeDim.TimeframeKey = ClientLatest.TimeframeKey),
         ClientMetricData
    AS (

       --MetricKey Query
       SELECT @Arg_ParticipantID ParticipantID,
              rDTL.MetricKey,
              1 AS JoinCondition
       FROM ClientMetricDM.dbo.vReportDTL rDTL
           INNER JOIN ClientMetricDM.dbo.vReportDIM rDIM
               ON rDIM.ReportKey = rDTL.ReportKey
       WHERE rDIM.ReportKey = ClientMetricDM.dbo.fn_GetReportVersion(@Arg_ReportType, @Arg_Timeframe, @Arg_ProductId)
	         --Following StartTimeframekey and EndTimeframekey filter is added by Geetha kamepalli as part of APPSUPPORT-10975
	         AND @Arg_Timeframe BETWEEN rDTL.StartTimeframeKey AND rDTL.EndTimeframeKey
             AND rDIM.ReportType = @Arg_ReportType
             AND rDIM.ProductID = @Arg_ProductId
             AND rDTL.SupressRowInd = 0
             AND rDTL.ReportSection = @Arg_ReportSection),
         TFLatest
    AS (SELECT A.TimeframeKey,
               A.TimeframeCode,
               1 AS JoinCondition
        FROM
        (
            SELECT TimeframeKey,
                   TimeframeCode
            FROM ClientMetricDM.dbo.vQuarterlyTimeframeDIM
            WHERE CONVERT(DATETIME, CONVERT(NVARCHAR, TimeframeKey))
            BETWEEN DATEADD(qq, -7, CONVERT(DATETIME, CONVERT(NVARCHAR, @Arg_Timeframe))) AND DATEADD(
                                                                                                         qq,
                                                                                                         -4,
                                                                                                         CONVERT(
                                                                                                                    DATETIME,
                                                                                                                    CONVERT(
                                                                                                                               NVARCHAR,
                                                                                                                               @Arg_Timeframe
                                                                                                                           )
                                                                                                                )
                                                                                                     )
        ) A ),
         TFSnapshot
    AS (SELECT a.TimeframeKey,
               a.TimeframeCode,
               1 AS JoinCondition
        FROM
        (
            SELECT TimeframeKey,
                   TimeframeCode
            FROM ClientMetricDM.dbo.vQuarterlyTimeframeDIM
            WHERE CONVERT(DATETIME, CONVERT(NVARCHAR, TimeframeKey))
            BETWEEN DATEADD(qq, -3, CONVERT(DATETIME, CONVERT(NVARCHAR, @Arg_Timeframe))) AND CONVERT(
                                                                                                         DATETIME,
                                                                                                         CONVERT(
                                                                                                                    NVARCHAR,
                                                                                                                    @Arg_Timeframe
                                                                                                                )
                                                                                                     )
        ) a ),
         ClientMetricTF
    AS (SELECT a.ParticipantID,
               a.MetricKey,
               a.TimeframeKey,
               a.TimeframeCode
        FROM
        (
            SELECT CMData.ParticipantID,
                   CMData.MetricKey,
                   TFL.TimeframeKey,
                   TFL.TimeframeCode
            FROM ClientMetricData CMData
                RIGHT JOIN TFLatest TFL
                    ON TFL.JoinCondition = CMData.JoinCondition
            UNION
            SELECT CMData.ParticipantID,
                   CMData.MetricKey,
                   TFS.TimeframeKey,
                   TFS.TimeframeCode
            FROM ClientMetricData CMData
                RIGHT JOIN TFSnapshot TFS
                    ON TFS.JoinCondition = CMData.JoinCondition
        ) a ),
         TrendData
    AS (SELECT ParticipantID,
               MetricKey,
               TimeframeKey,
               TimeframeCode,
               Value
        FROM
        (
            SELECT ParticipantID,
                   MetricKey,
                   TimeframeKey,
                   TimeframeCode,
                   Value
            FROM TrendClientSnapShot
            UNION
            SELECT ParticipantID,
                   MetricKey,
                   TimeframeKey,
                   TimeframeCode,
                   value
            FROM TrendClientLatest
        ) zz ),		
		allAggSnapSum
    AS (SELECT aggDIM.[AggregationKey],
               AASSum.[MetricKey],
               aggDIM.[ProductID],
               AASSum.[R4QTimeframeKey],
               CASE
                           WHEN RDTL.CalculationType IN ( 'COUNT', 'COUNTDISTINCT', 'AUC', 'SUM' ) THEN
                               ROUND(AASSum.[SnpsPctl50] * 100, RDTL.PercentageDecimalPrecision)
                           ELSE
                               ROUND(AASSum.[SnpsPctl50], RDTL.NumeratorDecimalPrecision)
                       END AS "US50thPctl"       
        FROM [ClientMetricDM].[dbo].[vAllAggregateSnapshotSUM] AASSum		
            INNER JOIN ClientMetricDM.dbo.vAggregationDIM aggDIM
                ON aggDIM.AggregationKey = AASSum.AggregationKey
            INNER JOIN ClientMetricDM.dbo.vReportDTL RDTL
                    ON AASSUM.MetricKey = RDTL.MetricKey
            INNER JOIN ClientMetricDM.dbo.vR4QTimeframeDIM R4QDIM
                ON R4QDIM.RollingYearTimeframeKey = AASSum.R4QTimeframeKey
        WHERE aggDIM.TimeframeKey = ClientMetricDM.dbo.fn_GetLatestPublishedQuarter(@Arg_Timeframe, @Arg_ProductId)
              AND aggDIM.ProductID = @Arg_ProductId
	      AND RDTL.ReportSection = @Arg_ReportSection
              AND aggDIM.RowIsCurrent = 1
			  AND @Arg_Timeframe BETWEEN RDTL.StartTimeframeKey AND rDTL.EndTimeframeKey
              AND R4QDIM.RollingYearTimeframeKey = ClientMetricDM.dbo.fn_GetLatestPublishedQuarter(
                                                                                                      @Arg_Timeframe,
                                                                                                      @Arg_ProductId
                                                                                                  )
              AND RDTL.ReportKey IN
                          (
                              SELECT ClientMetricDM.dbo.fn_GetReportVersion(
                                                                               @Arg_ReportType,
                                                                               @Arg_Timeframe,
                                                                               @Arg_ProductId
                                                                           ))
		
     
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
              ))
    SELECT 
	@Arg_ProductId AS ProductId,
	@Arg_ReportType AS ReportType,
	@Arg_Timeframe AS R4QTimeframe,
	CMTF.ParticipantID,
           CMTF.MetricKey,
           CMTF.TimeframeKey,
           CMTF.TimeframeCode,
           TData.Value,
		   allAggSnapSum.US50thPctl	AS "US Hospital 50th Percentile Value"   
    FROM ClientMetricTF CMTF
        LEFT OUTER JOIN TrendData TData		
            ON TData.ParticipantID = TData.ParticipantID
               AND CMTF.MetricKey = TData.MetricKey
               AND CMTF.TimeframeKey = TData.TimeframeKey
	    LEFT OUTER JOIN allAggSnapSum
            ON allAggSnapSum.MetricKey = TData.MetricKey
		ORDER BY CMTF.MetricKey;

END;
GO
