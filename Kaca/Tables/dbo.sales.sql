SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[sales] (
		[stor_id]      [char](4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[ord_num]      [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[ord_date]     [datetime] NOT NULL,
		[qty]          [smallint] NOT NULL,
		[payterms]     [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[title_id]     [dbo].[tid] NOT NULL
)
GO
ALTER TABLE [dbo].[sales]
	ADD
	CONSTRAINT [UPKCL_sales]
	PRIMARY KEY
	CLUSTERED
	([stor_id], [ord_num], [title_id])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[sales]
	WITH CHECK
	ADD CONSTRAINT [FK__sales__stor_id__108B795B]
	FOREIGN KEY ([stor_id]) REFERENCES [dbo].[stores] ([stor_id])
ALTER TABLE [dbo].[sales]
	CHECK CONSTRAINT [FK__sales__stor_id__108B795B]

GO
ALTER TABLE [dbo].[sales]
	WITH CHECK
	ADD CONSTRAINT [FK__sales__title_id__117F9D94]
	FOREIGN KEY ([title_id]) REFERENCES [dbo].[titles] ([title_id])
ALTER TABLE [dbo].[sales]
	CHECK CONSTRAINT [FK__sales__title_id__117F9D94]

GO
CREATE NONCLUSTERED INDEX [titleidind]
	ON [dbo].[sales] ([title_id])
	ON [PRIMARY]
GO
