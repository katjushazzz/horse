SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[AllAggregateSnapshotSUM_SWITCH] (
		[AggregationKey]            [int] NOT NULL,
		[MetricKey]                 [int] NOT NULL,
		[ProductID]                 [int] NOT NULL,
		[R4QTimeframeKey]           [int] NOT NULL,
		[SnpsAllR4QNumerator]       [decimal](12, 4) NULL,
		[SnpsAllR4QDenominator]     [int] NULL,
		[SnpsAllR4QPercentage]      [decimal](5, 4) NULL,
		[SnpsPctl0]                 [decimal](12, 4) NULL,
		[SnpsPctl5]                 [decimal](12, 4) NULL,
		[SnpsPctl10]                [decimal](12, 4) NULL,
		[SnpsPctl15]                [decimal](12, 4) NULL,
		[SnpsPctl25]                [decimal](12, 4) NULL,
		[SnpsPctl50]                [decimal](12, 4) NULL,
		[SnpsPctl75]                [decimal](12, 4) NULL,
		[SnpsPctl85]                [decimal](12, 4) NULL,
		[SnpsPctl90]                [decimal](12, 4) NULL,
		[SnpsPctl95]                [decimal](12, 4) NULL,
		[SnpsPctl100]               [decimal](12, 4) NULL,
		[SnpsTFPctl50]              [decimal](12, 4) NULL,
		[SnpsTFMinus1Pctl50]        [decimal](12, 4) NULL,
		[SnpsTFMinus2Pctl50]        [decimal](12, 4) NULL,
		[SnpsTFMinus3Pctl50]        [decimal](12, 4) NULL,
		CONSTRAINT [AllAggregateSnapshotSUM_SWITCH_PK]
		PRIMARY KEY
		CLUSTERED
		([AggregationKey], [MetricKey])
	ON [PS_AggregationKey] ([AggregationKey])
) ON [PS_AggregationKey] ([AggregationKey])
GO
CREATE NONCLUSTERED INDEX [IDX_AllAggregateSnapshotSUM_ProductID_R4QTimeframeKey_Inclues]
	ON [dbo].[AllAggregateSnapshotSUM_SWITCH] ([ProductID], [R4QTimeframeKey])
	INCLUDE ([AggregationKey], [MetricKey], [SnpsAllR4QNumerator], [SnpsAllR4QDenominator], [SnpsAllR4QPercentage], [SnpsPctl0], [SnpsPctl5], [SnpsPctl10], [SnpsPctl15], [SnpsPctl25], [SnpsPctl50], [SnpsPctl75], [SnpsPctl85], [SnpsPctl90], [SnpsPctl95], [SnpsPctl100])
	ON [PS_AggregationKey] ([AggregationKey])
GO
ALTER TABLE [dbo].[AllAggregateSnapshotSUM_SWITCH] SET (LOCK_ESCALATION = TABLE)
GO
