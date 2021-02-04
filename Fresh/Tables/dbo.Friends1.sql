SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Friends1] (
		[FriendID]     [int] NOT NULL,
		[Name]         [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Surname]      [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS MASKED WITH (FUNCTION = 'email()') NULL,
		[Test]         [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [PK__Friends1__A2CF6563E0C15BFF]
		PRIMARY KEY
		CLUSTERED
		([FriendID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Friends1] SET (LOCK_ESCALATION = TABLE)
GO
