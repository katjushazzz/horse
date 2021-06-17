SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AggregationTypeDIM] (
		[AggregationTypeKey]     [int] IDENTITY(1, 1) NOT NULL,
		[AggregationType]        [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[RowIsCurrent]           [bit] NULL,
		[MetricRollupKey]        [int] NULL,
		CONSTRAINT [PK_AggregationTypeDIM]
		PRIMARY KEY
		CLUSTERED
		([AggregationTypeKey])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AggregationTypeDIM]
	ADD
	CONSTRAINT [DF_AggregationTypeDIM_RowIsCurrent]
	DEFAULT ((1)) FOR [RowIsCurrent]
GO
ALTER TABLE [dbo].[AggregationTypeDIM]
	WITH CHECK
	ADD CONSTRAINT [FK_AggregationTypeDIM _MetricRollupDIM]
	FOREIGN KEY ([MetricRollupKey]) REFERENCES [dbo].[MetricRollupDIM] ([MetricRollupKey])
ALTER TABLE [dbo].[AggregationTypeDIM]
	CHECK CONSTRAINT [FK_AggregationTypeDIM _MetricRollupDIM]

GO
ALTER TABLE [dbo].[AggregationTypeDIM] SET (LOCK_ESCALATION = TABLE)
GO
