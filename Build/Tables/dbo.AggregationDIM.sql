SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AggregationDIM] (
		[AggregationKey]                    [int] NOT NULL,
		[ProductID]                         [int] NOT NULL,
		[AggregationDateTime]               [datetime] NOT NULL,
		[TimeframeKey]                      [int] NOT NULL,
		[AsOfDateTime]                      [datetime] NOT NULL,
		[TimeFrameDisplayText]              [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TFMinus1TimeframeKey]              [int] NULL,
		[TFMinus1DisplayText]               [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TFMinus2TimeframeKey]              [int] NULL,
		[TFMinus2DisplayText]               [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TFMinus3TimeframeKey]              [int] NULL,
		[TFMinus3DisplayText]               [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[AggregationTypeKey]                [int] NULL,
		[AggregationType]                   [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ETLLogIDInsert]                    [int] NOT NULL,
		[ETLLogIDUpdate]                    [int] NOT NULL,
		[InsertTime]                        [datetime] NOT NULL,
		[UpdateTime]                        [datetime] NOT NULL,
		[RowIsCurrent]                      [bit] NOT NULL,
		[RowStartDate]                      [datetime] NOT NULL,
		[RowEndDate]                        [datetime] NOT NULL,
		[IsPublished]                       [bit] NULL,
		[IsPublicReporting]                 [bit] NULL,
		[IsPublishedForPublicReporting]     [bit] NULL,
		[IsAvailableForPublicReporting]     [bit] NULL,
		CONSTRAINT [AggregationDIM_PK]
		PRIMARY KEY
		CLUSTERED
		([AggregationKey])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AggregationDIM]
	ADD
	CONSTRAINT [DF__Aggregati__RowIs__7F60ED59]
	DEFAULT ((0)) FOR [RowIsCurrent]
GO
ALTER TABLE [dbo].[AggregationDIM]
	ADD
	CONSTRAINT [DF__Aggregati__RowEn__00551192]
	DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [dbo].[AggregationDIM]
	ADD
	CONSTRAINT [DF__Aggregati__IsPub__014935CB]
	DEFAULT ((0)) FOR [IsPublicReporting]
GO
ALTER TABLE [dbo].[AggregationDIM]
	ADD
	CONSTRAINT [DF__Aggregati__IsPub__023D5A04]
	DEFAULT ((0)) FOR [IsPublishedForPublicReporting]
GO
ALTER TABLE [dbo].[AggregationDIM]
	ADD
	CONSTRAINT [DF__Aggregati__IsAva__03317E3D]
	DEFAULT ((0)) FOR [IsAvailableForPublicReporting]
GO
ALTER TABLE [dbo].[AggregationDIM] SET (LOCK_ESCALATION = TABLE)
GO
