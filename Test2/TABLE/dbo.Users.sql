SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE TABLE [dbo].[Users] (
	[UserID] uniqueidentifier NOT NULL,
	[Sid] varbinary(85),
	[UserType] int NOT NULL,
	[AuthType] int NOT NULL,
	[UserName] nvarchar(260) COLLATE SQL_Latin1_General_CP1_CI_AS,
	CONSTRAINT [PK_Users] PRIMARY KEY NONCLUSTERED([UserID]) WITH (FILLFACTOR=100) ON [PRIMARY]
) ON [PRIMARY]
CREATE UNIQUE CLUSTERED INDEX [IX_Users]
 ON [dbo].[Users] ([Sid], [UserName], [AuthType])
ON [PRIMARY]