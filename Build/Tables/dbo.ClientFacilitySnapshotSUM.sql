SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ClientFacilitySnapshotSUM] (
		[AggregationKey]              [int] NOT NULL,
		[MetricKey]                   [int] NOT NULL,
		[ClientKey]                   [int] NOT NULL,
		[FacilityTypeKey]             [int] NULL,
		[FacilityKey]                 [int] NOT NULL,
		[ProductID]                   [int] NOT NULL,
		[R4QTimeframeKey]             [int] NOT NULL,
		[SnpsTFNumerator]             [decimal](12, 4) NULL,
		[SnpsTFDenominator]           [int] NULL,
		[SnpsTFPercentage]            [decimal](5, 4) NULL,
		[SnpsTFMinus1Numerator]       [decimal](12, 4) NULL,
		[SnpsTFMinus1Denominator]     [int] NULL,
		[SnpsTFMinus1Percentage]      [decimal](5, 4) NULL,
		[SnpsTFMinus2Numerator]       [decimal](12, 4) NULL,
		[SnpsTFMinus2Denominator]     [int] NULL,
		[SnpsTFMinus2Percentage]      [decimal](5, 4) NULL,
		[SnpsTFMinus3Numerator]       [decimal](12, 4) NULL,
		[SnpsTFMinus3Denominator]     [int] NULL,
		[SnpsTFMinus3Percentage]      [decimal](5, 4) NULL,
		[SnpsR4QNumerator]            [decimal](12, 4) NULL,
		[SnpsR4QDenominator]          [int] NULL,
		[SnpsR4QPercentage]           [decimal](5, 4) NULL,
		[SnpsR4QPercentile]           [decimal](5, 4) NULL,
		CONSTRAINT [PK_ClientFacilitySnapshotSUM]
		PRIMARY KEY
		CLUSTERED
		([AggregationKey], [ClientKey], [MetricKey], [FacilityKey])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientFacilitySnapshotSUM] SET (LOCK_ESCALATION = TABLE)
GO
