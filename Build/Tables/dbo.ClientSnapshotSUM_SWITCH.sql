SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ClientSnapshotSUM_SWITCH] (
		[AggregationKey]                [int] NOT NULL,
		[MetricKey]                     [int] NOT NULL,
		[ClientKey]                     [int] NOT NULL,
		[ClientSnapshotKey]             [bigint] NOT NULL,
		[ProductID]                     [int] NOT NULL,
		[R4QTimeframeKey]               [int] NOT NULL,
		[ComparisonGroupKey]            [int] NOT NULL,
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
		CONSTRAINT [UX_ClientSnapshotKey_SWITCH]
		UNIQUE
		NONCLUSTERED
		([AggregationKey], [ClientSnapshotKey])
		ON [PS_AggregationKey] ([AggregationKey]),
		CONSTRAINT [PK_ClientSnapshotSUM_SWITCH]
		PRIMARY KEY
		CLUSTERED
		([AggregationKey], [ClientKey], [MetricKey])
	ON [PS_AggregationKey] ([AggregationKey])
) ON [PS_AggregationKey] ([AggregationKey])
GO
CREATE NONCLUSTERED INDEX [IDX_ClientSnapshotSUM_SWITCH_AggregationKey_R4QTimeframeKey_Clientkey]
	ON [dbo].[ClientSnapshotSUM_SWITCH] ([AggregationKey], [R4QTimeframeKey], [ClientKey])
	ON [PS_AggregationKey] ([AggregationKey])
GO
ALTER TABLE [dbo].[ClientSnapshotSUM_SWITCH] SET (LOCK_ESCALATION = TABLE)
GO
