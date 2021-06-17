SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MyMetricType] (
		[MyMetricTypeKey]      [int] IDENTITY(1, 1) NOT NULL,
		[MyMetricTypeCode]     [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[MyMetricTypeName]     [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CreatedDate]          [datetime2](7) NULL,
		[UpdatedDate]          [datetime2](7) NULL,
		CONSTRAINT [PK_MyMetricType]
		PRIMARY KEY
		CLUSTERED
		([MyMetricTypeKey])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MyMetricType]
	ADD
	CONSTRAINT [DF_MyMetricType_CreatedDate]
	DEFAULT (sysdatetime()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[MyMetricType]
	ADD
	CONSTRAINT [DF_MyMetricType_UpdatedDate]
	DEFAULT (sysdatetime()) FOR [UpdatedDate]
GO
ALTER TABLE [dbo].[MyMetricType] SET (LOCK_ESCALATION = TABLE)
GO
