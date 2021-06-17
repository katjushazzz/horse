SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MyMetrics] (
		[MyMetricKey]         [int] IDENTITY(1, 1) NOT NULL,
		[Clientkey]           [int] NOT NULL,
		[ProductID]           [int] NOT NULL,
		[MetricKey]           [int] NOT NULL,
		[UserName]            [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[MyMetricTypeKey]     [int] NULL,
		[RowIsCurrent]        [bit] NOT NULL,
		[CreatedDate]         [datetime2](7) NOT NULL,
		[UpdatedDate]         [datetime2](7) NOT NULL,
		[ClientID]            [int] NULL,
		CONSTRAINT [UQ_MyMetrics_ClientKey_MetricKey_MyMetricTypeKey_ProductID]
		UNIQUE
		NONCLUSTERED
		([Clientkey], [MetricKey], [MyMetricTypeKey], [ProductID])
		ON [PRIMARY],
		CONSTRAINT [PK_MyMetrics]
		PRIMARY KEY
		CLUSTERED
		([MyMetricKey])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MyMetrics]
	ADD
	CONSTRAINT [DF_MyMetrics_RowIscurrent]
	DEFAULT ((1)) FOR [RowIsCurrent]
GO
ALTER TABLE [dbo].[MyMetrics]
	ADD
	CONSTRAINT [DF_MyMetrics_CreatedDate]
	DEFAULT (sysdatetime()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[MyMetrics]
	ADD
	CONSTRAINT [DF_MyMetrics_UpdatedDate]
	DEFAULT (sysdatetime()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[MyMetrics]
	WITH CHECK
	ADD CONSTRAINT [FK_MyMetrics_MyMetricType]
	FOREIGN KEY ([MyMetricTypeKey]) REFERENCES [dbo].[MyMetricType] ([MyMetricTypeKey])
ALTER TABLE [dbo].[MyMetrics]
	CHECK CONSTRAINT [FK_MyMetrics_MyMetricType]

GO
ALTER TABLE [dbo].[MyMetrics] SET (LOCK_ESCALATION = TABLE)
GO
