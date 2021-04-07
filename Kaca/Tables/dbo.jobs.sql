SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[jobs] (
		[job_id]       [smallint] IDENTITY(1, 1) NOT NULL,
		[job_desc]     [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[min_lvl]      [tinyint] NOT NULL,
		[max_lvl]      [tinyint] NOT NULL,
		[01]           [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[jobs]
	ADD
	CONSTRAINT [PK__jobs__173876EA]
	PRIMARY KEY
	CLUSTERED
	([job_id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[jobs]
	ADD
	CONSTRAINT [CK__jobs__min_lvl__1920BF5C]
	CHECK
	([min_lvl]>=(10))
GO
ALTER TABLE [dbo].[jobs]
CHECK CONSTRAINT [CK__jobs__min_lvl__1920BF5C]
GO
ALTER TABLE [dbo].[jobs]
	ADD
	CONSTRAINT [CK__jobs__max_lvl__1A14E395]
	CHECK
	([max_lvl]<=(250))
GO
ALTER TABLE [dbo].[jobs]
CHECK CONSTRAINT [CK__jobs__max_lvl__1A14E395]
GO
ALTER TABLE [dbo].[jobs]
	ADD
	CONSTRAINT [DF__jobs__job_desc__182C9B23]
	DEFAULT ('New Position - title not formalized yet') FOR [job_desc]
GO
