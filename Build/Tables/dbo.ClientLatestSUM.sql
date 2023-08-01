SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ClientLatestSUM] (
		[ClientKey]             [int] NOT NULL,
		[TimeframeKey]          [int] NOT NULL,
		[MetricKey]             [int] NOT NULL,
		[ProductID]             [int] NOT NULL,
		[Numerator]             [decimal](12, 4) NULL,
		[Denominator]           [int] NULL,
		[Percentage]            [decimal](5, 4) NULL,
		[AggregationKey]        [int] NOT NULL,
		[ClientSnapshotKey]     [bigint] NOT NULL,
		[MetricRollupKey]       [int] NOT NULL,
		CONSTRAINT [ClientLatestSUM_PK]
		PRIMARY KEY
		CLUSTERED
		([TimeframeKey], [MetricKey], [ClientKey], [ProductID], [MetricRollupKey])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientLatestSUM] SET (LOCK_ESCALATION = TABLE)
GO