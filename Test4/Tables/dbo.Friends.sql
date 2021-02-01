SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Friends] (
		[FriendID]     [int] NOT NULL,
		[Name]         [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Surname]      [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS MASKED WITH (FUNCTION = 'email()') NULL,
		[Test]         [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [PK__Friends__A2CF6563901DC937]
		PRIMARY KEY
		CLUSTERED
		([FriendID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Friends] SET (LOCK_ESCALATION = TABLE)
GO
