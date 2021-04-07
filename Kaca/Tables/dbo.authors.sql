SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[authors] (
		[au_id]        [dbo].[id] NOT NULL,
		[au_lname]     [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[au_fname]     [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[phone]        [char](12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[address]      [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[city]         [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[state]        [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[zip]          [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[contract]     [bit] NOT NULL,
		[Test3]         [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
)
GO
ALTER TABLE [dbo].[authors]
	ADD
	CONSTRAINT [UPKCL_auidind]
	PRIMARY KEY
	CLUSTERED
	([au_id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[authors]
	ADD
	CONSTRAINT [DF__authors__phone__7E6CC920]
	DEFAULT ('UNKNOWN') FOR [phone]
GO
CREATE NONCLUSTERED INDEX [aunmind]
	ON [dbo].[authors] ([au_lname], [au_fname])
	ON [PRIMARY]
GO
