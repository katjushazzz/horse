SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[hh] (
		[Col1]          [int] NULL,
		[Col2]          [int] NULL,
		[FirstName]     [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[LastName]      [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Name]          [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ime]           [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[prezime]       [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[hh] SET (LOCK_ESCALATION = TABLE)
GO
