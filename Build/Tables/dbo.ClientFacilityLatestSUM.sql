SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ClientFacilityLatestSUM] (
		[ClientKey]           [int] NOT NULL,
		[FacilityTypeKey]     [int] NOT NULL,
		[FacilityKey]         [int] NOT NULL,
		[TimeframeKey]        [int] NOT NULL,
		[MetricKey]           [int] NOT NULL,
		[ProductID]           [int] NOT NULL,
		[Numerator]           [decimal](12, 4) NULL,
		[Denominator]         [int] NULL,
		[Percentage]          [decimal](5, 4) NULL,
		[AggregationKey]      [int] NULL,
		[MetricRollupKey]     [int] NOT NULL,
		CONSTRAINT [ClientFacilityLatestSUM_PK]
		PRIMARY KEY
		CLUSTERED
		([TimeframeKey], [MetricKey], [ClientKey], [ProductID], [MetricRollupKey], [FacilityTypeKey], [FacilityKey])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientFacilityLatestSUM] SET (LOCK_ESCALATION = TABLE)
GO
