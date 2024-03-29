SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[roysched] (
		[title_id]     [dbo].[tid] NOT NULL,
		[lorange]      [int] NULL,
		[hirange]      [int] NULL,
		[royalty]      [int] NULL
)
GO
ALTER TABLE [dbo].[roysched]
	WITH CHECK
	ADD CONSTRAINT [FK__roysched__title___1367E606]
	FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
ALTER TABLE [dbo].[roysched]
	CHECK CONSTRAINT [FK__roysched__title___1367E606]

GO
CREATE NONCLUSTERED INDEX [titleidind]
	ON [dbo].[roysched] ([title_id])
	ON [PRIMARY]
GO
