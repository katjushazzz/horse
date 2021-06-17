SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MetricRollupDIM] (
		[MetricRollupKey]     [int] IDENTITY(1, 1) NOT NULL,
		[Name]                [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Description]         [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [PK_MetricRollupDIM]
		PRIMARY KEY
		CLUSTERED
		([MetricRollupKey])
	ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[MetricRollupDIM] SET (LOCK_ESCALATION = TABLE)
GO
