SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ClientFCT] (
		[AggregationKey]             [int] NOT NULL,
		[ClientKey]                  [int] NOT NULL,
		[ProductID]                  [int] NOT NULL,
		[TimeframeKey]               [int] NOT NULL,
		[ComparisonGroupKey]         [int] NOT NULL,
		[AnnualizedProcVol]          [int] NULL,
		[TFBenchmarkCode]            [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TFPopulationCode]           [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TFMinus1TimeframeKey]       [int] NOT NULL,
		[TFMinus1BenchmarkCode]      [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TFMinus1PopulationCode]     [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TFMinus2TimeframeKey]       [int] NOT NULL,
		[TFMinus2BenchmarkCode]      [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TFMinus2PopulationCode]     [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TFMinus3TimeframeKey]       [int] NOT NULL,
		[TFMinus3BenchmarkCode]      [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TFMinus3PopulationCode]     [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [PK_ClientFCT]
		PRIMARY KEY
		CLUSTERED
		([AggregationKey], [ClientKey])
	ON [PS_AggregationKey] ([AggregationKey])
) ON [PS_AggregationKey] ([AggregationKey])
GO
ALTER TABLE [dbo].[ClientFCT] SET (LOCK_ESCALATION = TABLE)
GO
