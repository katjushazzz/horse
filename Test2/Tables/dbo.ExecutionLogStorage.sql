SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ExecutionLogStorage] (
		[LogEntryId]            [bigint] IDENTITY(1, 1) NOT NULL,
		[InstanceName]          [nvarchar](38) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[ReportID]              [uniqueidentifier] NULL,
		[UserName]              [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ExecutionId]           [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[RequestType]           [tinyint] NOT NULL,
		[Format]                [nvarchar](26) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Parameters]            [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ReportAction]          [tinyint] NULL,
		[TimeStart]             [datetime] NOT NULL,
		[TimeEnd]               [datetime] NOT NULL,
		[TimeDataRetrieval]     [int] NOT NULL,
		[TimeProcessing]        [int] NOT NULL,
		[TimeRendering]         [int] NOT NULL,
		[Source]                [tinyint] NOT NULL,
		[Status]                [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[ByteCount]             [bigint] NOT NULL,
		[RowCount]              [bigint] NOT NULL,
		[AdditionalInfo]        [xml] NULL,
		CONSTRAINT [PK__Executio__05F5D74544FEA093]
		PRIMARY KEY
		CLUSTERED
		([LogEntryId])
	ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ExecutionLog]
	ON [dbo].[ExecutionLogStorage] ([TimeStart], [LogEntryId])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[ExecutionLogStorage] SET (LOCK_ESCALATION = TABLE)
GO
