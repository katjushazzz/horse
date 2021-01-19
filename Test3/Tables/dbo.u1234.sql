SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[u1234] (
		[g]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[h]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[i]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[y]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[o]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[u1234] SET (LOCK_ESCALATION = TABLE)
GO
