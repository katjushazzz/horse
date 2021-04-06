SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ErrorLog] (
		[ErrorLogID]         [int] IDENTITY(1, 1) NOT NULL,
		[ErrorTime]          [datetime] NOT NULL,
		[UserName]           [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[ErrorNumber]        [int] NOT NULL,
		[ErrorSeverity]      [int] NULL,
		[ErrorState]         [int] NULL,
		[ErrorProcedure]     [nvarchar](126) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ErrorLine]          [int] NULL,
		[ErrorMessage]       [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Test]               [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test3]              [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test4]              [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test5]              [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [PK_ErrorLog_ErrorLogID]
		PRIMARY KEY
		CLUSTERED
		([ErrorLogID])
)
GO
ALTER TABLE [dbo].[ErrorLog]
	ADD
	CONSTRAINT [DF_ErrorLog_ErrorTime]
	DEFAULT (getdate()) FOR [ErrorTime]
GO
ALTER TABLE [dbo].[ErrorLog] SET (LOCK_ESCALATION = TABLE)
GO
