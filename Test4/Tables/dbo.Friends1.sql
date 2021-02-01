SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Friends1] (
		[FriendID]     [int] IDENTITY(1, 1) NOT NULL,
		[Name]         [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Surname]      [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test]         [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test2]        [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test4]        [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test5]        [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test6]        [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test7]        [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [PK__Friends__A2CF6563A4A157C1]
		PRIMARY KEY
		CLUSTERED
		([FriendID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Friends1] SET (LOCK_ESCALATION = TABLE)
GO
