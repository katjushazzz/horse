SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [ACC-INFO\hbedada].[AllAggregateFacilitySnapshotSUM] (
		[AggregationKey]            [int] NOT NULL,
		[MetricKey]                 [int] NULL,
		[FacilityTypeKey]           [int] NULL,
		[ProductID]                 [int] NULL,
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
		[SnpsTFMinus3Pctl50]        [decimal](12, 4) NULL
) ON [PRIMARY]
GO
ALTER TABLE [ACC-INFO\hbedada].[AllAggregateFacilitySnapshotSUM] SET (LOCK_ESCALATION = TABLE)
GO
