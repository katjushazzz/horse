SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[History] (
		[HistoryID]          [uniqueidentifier] NOT NULL,
		[ReportID]           [uniqueidentifier] NOT NULL,
		[SnapshotDataID]     [uniqueidentifier] NOT NULL,
		[SnapshotDate2]      [datetime] NOT NULL,
		[Test6]              [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test24]             [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [PK_History]
		PRIMARY KEY
		NONCLUSTERED
		([HistoryID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [IX_History]
	ON [dbo].[History] ([ReportID], [SnapshotDate2])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SnapshotDataID]
	ON [dbo].[History] ([SnapshotDataID])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[History] SET (LOCK_ESCALATION = TABLE)
GO
