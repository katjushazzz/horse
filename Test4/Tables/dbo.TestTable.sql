SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TestTable] (
		[Col1]          [int] NULL,
		[Col2]          [int] NULL,
		[FirstName]     [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[LastName]      [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Name]          [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ime]           [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[prezime]       [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TestTable] SET (LOCK_ESCALATION = TABLE)
GO
