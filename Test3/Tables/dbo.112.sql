SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[112] (
		[Item]       [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Status]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test]       [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test2]      [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[112] SET (LOCK_ESCALATION = TABLE)
GO
