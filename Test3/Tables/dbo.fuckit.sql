SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[fuckit] (
		[h]                                                                     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[i]                                                                     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[p]                                                                     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[r]                                                                     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[DevExpress.XtraRichEdit.API.Native.Implementation.NativeTableCell]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[fuckit] SET (LOCK_ESCALATION = TABLE)
GO
