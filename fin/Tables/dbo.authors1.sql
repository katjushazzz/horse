SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[authors1] (
		[au_id]        [dbo].[id] NOT NULL,
		[au_lname]     [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[au_fname]     [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[phone]        [char](12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[address2]     [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[city]         [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[state]        [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[zip]          [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[contract]     [bit] NOT NULL,
		CONSTRAINT [UPKCL_auidind]
		PRIMARY KEY
		CLUSTERED
		([au_id])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[authors1]
	ADD
	CONSTRAINT [CK__authors__au_id__37A5467C]
	CHECK
	([au_id] like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]')
GO
ALTER TABLE [dbo].[authors1]
CHECK CONSTRAINT [CK__authors__au_id__37A5467C]
GO
ALTER TABLE [dbo].[authors1]
	ADD
	CONSTRAINT [CK__authors__zip__398D8EEE]
	CHECK
	([zip] like '[0-9][0-9][0-9][0-9][0-9]')
GO
ALTER TABLE [dbo].[authors1]
CHECK CONSTRAINT [CK__authors__zip__398D8EEE]
GO
ALTER TABLE [dbo].[authors1]
	ADD
	CONSTRAINT [DF__authors__phone__38996AB5]
	DEFAULT ('UNKNOWN') FOR [phone]
GO
CREATE NONCLUSTERED INDEX [aunmind]
	ON [dbo].[authors1] ([au_lname], [au_fname])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[authors1] SET (LOCK_ESCALATION = TABLE)
GO
