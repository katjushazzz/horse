SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[titleauthor] (
		[au_id]          [dbo].[id] NOT NULL,
		[title_id]       [dbo].[tid] NOT NULL,
		[au_ord]         [tinyint] NULL,
		[royaltyper]     [int] NULL
)
GO
ALTER TABLE [dbo].[titleauthor]
	ADD
	CONSTRAINT [UPKCL_taind]
	PRIMARY KEY
	CLUSTERED
	([au_id], [title_id])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [auidind]
	ON [dbo].[titleauthor] ([au_id])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [titleidind]
	ON [dbo].[titleauthor] ([title_id])
	ON [PRIMARY]
GO
