SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ComparisonGroupSnapshotDTL_SWITCH] (
		[ComparisonGroupKey]     [int] NOT NULL,
		[AggregationKey]         [int] NOT NULL,
		[ProductID]              [int] NULL,
		[ClientKey]              [int] NOT NULL,
		CONSTRAINT [PK_ComparisonGroupSnapshotDTL_SWITCH]
		PRIMARY KEY
		CLUSTERED
		([AggregationKey], [ComparisonGroupKey], [ClientKey])
	ON [PS_AggregationKey] ([AggregationKey])
) ON [PS_AggregationKey] ([AggregationKey])
GO
ALTER TABLE [dbo].[ComparisonGroupSnapshotDTL_SWITCH] SET (LOCK_ESCALATION = TABLE)
GO
