SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SubmissionSnapshot] (
		[ProductID]          [int] NOT NULL,
		[AggregationKey]     [int] NOT NULL,
		[SubmissionKey]      [int] NOT NULL,
		[ClientKey]          [int] NULL,
		[TimeframeKey]       [int] NULL,
		[BenchmarkCode]      [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [PK_SubmissionSnapshot]
		PRIMARY KEY
		CLUSTERED
		([AggregationKey], [SubmissionKey])
	ON [PS_AggregationKey] ([AggregationKey])
) ON [PS_AggregationKey] ([AggregationKey])
GO
ALTER TABLE [dbo].[SubmissionSnapshot] SET (LOCK_ESCALATION = TABLE)
GO
