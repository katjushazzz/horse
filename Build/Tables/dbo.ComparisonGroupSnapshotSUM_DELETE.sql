SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ComparisonGroupSnapshotSUM_DELETE] (
		[AggregationKey]              [int] NOT NULL,
		[ComparisonGroupKey]          [int] NOT NULL,
		[MetricKey]                   [int] NOT NULL,
		[ProductID]                   [int] NOT NULL,
		[R4QTimeframeKey]             [int] NOT NULL,
		[SnpsGroupR4QNumerator]       [decimal](12, 4) NULL,
		[SnpsGroupR4QDenominator]     [int] NULL,
		[SnpsGroupR4QPercentage]      [decimal](5, 4) NULL,
		[SnpsGroupPctl0]              [decimal](12, 4) NULL,
		[SnpsGroupPctl5]              [decimal](12, 4) NULL,
		[SnpsGroupPctl10]             [decimal](12, 4) NULL,
		[SnpsGroupPctl15]             [decimal](12, 4) NULL,
		[SnpsGroupPctl25]             [decimal](12, 4) NULL,
		[SnpsGroupPctl50]             [decimal](12, 4) NULL,
		[SnpsGroupPctl75]             [decimal](12, 4) NULL,
		[SnpsGroupPctl85]             [decimal](12, 4) NULL,
		[SnpsGroupPctl90]             [decimal](12, 4) NULL,
		[SnpsGroupPctl95]             [decimal](12, 4) NULL,
		[SnpsGroupPctl100]            [decimal](12, 4) NULL,
		[SnpsTFPctl50]                [decimal](12, 4) NULL,
		[SnpsTFMinus1Pctl50]          [decimal](12, 4) NULL,
		[SnpsTFMinus2Pctl50]          [decimal](12, 4) NULL,
		[SnpsTFMinus3Pctl50]          [decimal](12, 4) NULL,
		[ETLLogIDInsert]              [int] NULL,
		[ETLLogIDUpdate]              [int] NULL,
		[InsertTime]                  [datetime2](7) NULL,
		[UpdateTime]                  [datetime2](7) NULL,
		CONSTRAINT [PK_ComparisonGroupSnapshotSUM_DELETE]
		PRIMARY KEY
		CLUSTERED
		([AggregationKey], [ComparisonGroupKey], [MetricKey])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ComparisonGroupSnapshotSUM_DELETE] SET (LOCK_ESCALATION = TABLE)
GO
