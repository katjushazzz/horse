SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[fuck1] (
		[t]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[h]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[i]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[o]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[w]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[fuck1] SET (LOCK_ESCALATION = TABLE)
GO
