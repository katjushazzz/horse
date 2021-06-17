SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ClientLatestSUM_INSERT] (
		[ClientKey]             [int] NOT NULL,
		[TimeframeKey]          [int] NOT NULL,
		[MetricKey]             [int] NOT NULL,
		[ProductID]             [int] NOT NULL,
		[Numerator]             [decimal](12, 4) NULL,
		[Denominator]           [int] NULL,
		[Percentage]            [decimal](5, 4) NULL,
		[AggregationKey]        [int] NOT NULL,
		[ClientSnapshotKey]     [bigint] NOT NULL,
		[ETLLogIDInsert]        [int] NULL,
		[ETLLogIDUpdate]        [int] NULL,
		[InsertTime]            [datetime] NULL,
		[UpdateTime]            [datetime] NULL,
		[MetricRollupKey]       [int] NULL,
		CONSTRAINT [ClientLatestSUM_INSERT_PK]
		PRIMARY KEY
		CLUSTERED
		([TimeframeKey], [MetricKey], [ClientKey], [ProductID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientLatestSUM_INSERT] SET (LOCK_ESCALATION = TABLE)
GO
