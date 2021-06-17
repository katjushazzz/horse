SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [ACC-INFO\hbedada].[ClientFacilityLatestSUM] (
		[ClientKey]           [int] NOT NULL,
		[FacilityTypeKey]     [int] NULL,
		[FacilityKey]         [int] NULL,
		[TimeframeKey]        [int] NOT NULL,
		[MetricKey]           [int] NULL,
		[ProductID]           [int] NULL,
		[Numerator]           [decimal](12, 4) NULL,
		[Denominator]         [int] NULL,
		[Percentage]          [decimal](5, 4) NULL,
		[AggregationKey]      [int] NOT NULL,
		[MetricRollupKey]     [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [ACC-INFO\hbedada].[ClientFacilityLatestSUM] SET (LOCK_ESCALATION = TABLE)
GO
