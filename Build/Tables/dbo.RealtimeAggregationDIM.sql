SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RealtimeAggregationDIM] (
		[AggregationKey]         [int] NULL,
		[ProductID]              [int] NULL,
		[TFOffset]               [int] NULL,
		[TFOffsetDesc]           [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[AggregationTypeKey]     [int] NULL,
		[AggregationType]        [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[RowIsCurrent]           [bit] NULL,
		[RowStartDate]           [datetime] NULL,
		[RowEndDate]             [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RealtimeAggregationDIM]
	ADD
	CONSTRAINT [DF__RealtimeA__RowEn__74AE54BC]
	DEFAULT ('9999/12/31') FOR [RowEndDate]
GO
ALTER TABLE [dbo].[RealtimeAggregationDIM] SET (LOCK_ESCALATION = TABLE)
GO
