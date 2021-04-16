SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[jobs1] (
		[job_id]       [smallint] IDENTITY(1, 1) NOT NULL,
		[job_desc]     [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[min_lvl]      [tinyint] NOT NULL,
		[max_lvl]      [tinyint] NOT NULL,
		CONSTRAINT [PK__jobs__6E32B6A5F517E0E1]
		PRIMARY KEY
		CLUSTERED
		([job_id])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[jobs1]
	ADD
	CONSTRAINT [CK__jobs__min_lvl__534D60F1]
	CHECK
	([min_lvl]>=(10))
GO
ALTER TABLE [dbo].[jobs1]
CHECK CONSTRAINT [CK__jobs__min_lvl__534D60F1]
GO
ALTER TABLE [dbo].[jobs1]
	ADD
	CONSTRAINT [CK__jobs__max_lvl__5441852A]
	CHECK
	([max_lvl]<=(250))
GO
ALTER TABLE [dbo].[jobs1]
CHECK CONSTRAINT [CK__jobs__max_lvl__5441852A]
GO
ALTER TABLE [dbo].[jobs1]
	ADD
	CONSTRAINT [DF__jobs__job_desc__52593CB8]
	DEFAULT ('New Position - title not formalized yet') FOR [job_desc]
GO
ALTER TABLE [dbo].[jobs1] SET (LOCK_ESCALATION = TABLE)
GO
