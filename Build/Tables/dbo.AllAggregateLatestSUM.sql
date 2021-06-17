SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[AllAggregateLatestSUM] (
		[TimeframeKey]       [int] NOT NULL,
		[MetricKey]          [int] NOT NULL,
		[ProductID]          [int] NOT NULL,
		[AllNumerator]       [decimal](12, 4) NULL,
		[AllDenominator]     [int] NULL,
		[AllPercentage]      [decimal](5, 4) NULL,
		[AggregationKey]     [int] NOT NULL,
		CONSTRAINT [AllAggregateLatestSUM_PK]
		PRIMARY KEY
		CLUSTERED
		([TimeframeKey], [MetricKey], [ProductID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AllAggregateLatestSUM] SET (LOCK_ESCALATION = TABLE)
GO
