SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ClientSnapshotSUM_DELETE] (
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
		[ETLLogIDInsert]                [int] NULL,
		[ETLLogIDUpdate]                [int] NULL,
		[InsertTime]                    [datetime2](7) NULL,
		[UpdateTime]                    [datetime2](7) NULL,
		CONSTRAINT [UX_ClientSnapshotKey_DELETE]
		UNIQUE
		NONCLUSTERED
		([AggregationKey], [ClientSnapshotKey])
		ON [PRIMARY],
		CONSTRAINT [PK_ClientSnapshotSUM_DELETE]
		PRIMARY KEY
		CLUSTERED
		([AggregationKey], [ClientKey], [MetricKey])
	ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_ClientSnapshotSUM_DELETE_ClientKey]
	ON [dbo].[ClientSnapshotSUM_DELETE] ([ClientKey], [AggregationKey])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_ClientSnapshotSUM_DELETE_MetricKey]
	ON [dbo].[ClientSnapshotSUM_DELETE] ([MetricKey], [AggregationKey])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_ClientSnapshotSUM_DELETE_MetricKey_ClientKey_R4QTimeframeKey]
	ON [dbo].[ClientSnapshotSUM_DELETE] ([MetricKey], [ClientKey], [R4QTimeframeKey], [AggregationKey])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_ClientSnapshotSUM_DELETE_R4QTimeframeKey]
	ON [dbo].[ClientSnapshotSUM_DELETE] ([R4QTimeframeKey], [AggregationKey])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientSnapshotSUM_DELETE] SET (LOCK_ESCALATION = TABLE)
GO
