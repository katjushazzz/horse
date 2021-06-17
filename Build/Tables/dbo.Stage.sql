SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Stage] (
		[DetailLineNum]                 [int] NULL,
		[AggregationKey]                [int] NULL,
		[MetricKey]                     [int] NULL,
		[ClientKey]                     [int] NULL,
		[ClientSnapshotKey]             [bigint] NULL,
		[ProductID]                     [int] NULL,
		[R4QTimeframeKey]               [int] NULL,
		[ComparisonGroupKey]            [int] NULL,
		[SnpsTFNumerator]               [decimal](12, 4) NULL,
		[SnpsTFDenominator]             [int] NULL,
		[SnpsTFPercentage]              [decimal](5, 4) NULL,
		[SnpsTFMinus1Numerator]         [decimal](12, 4) NULL,
		[SnpsTFMinus1Denominator]       [int] NULL,
		[SnpsTFMinus1Percentage]        [decimal](5, 4) NULL,
		[SnpsTFMinus2Numerator]         [decimal](12, 4) NULL,
		[SnpsTFMinus2Denominator]       [int] NULL,
		[SnpsTFMinus2Percentage]        [decimal](5, 4) NULL,
		[SnpsTFMinus3Numerator]         [decimal](12, 4) NULL,
		[SnpsTFMinus3Denominator]       [int] NULL,
		[SnpsTFMinus3Percentage]        [decimal](5, 4) NULL,
		[SnpsR4QNumerator]              [decimal](12, 4) NULL,
		[SnpsR4QDenominator]            [int] NULL,
		[SnpsR4QPercentage]             [decimal](5, 4) NULL,
		[SnpsR4QPercentile]             [decimal](5, 4) NULL,
		[SnpsR4QConfidencePos]          [decimal](5, 2) NULL,
		[SnpsR4QConfidenceNeg]          [decimal](5, 2) NULL,
		[ComparisonGroupPercentile]     [decimal](5, 4) NULL,
		[LineText]                      [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Stage] SET (LOCK_ESCALATION = TABLE)
GO
