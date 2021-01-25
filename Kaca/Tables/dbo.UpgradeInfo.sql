SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UpgradeInfo] (
		[Item]       [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Status]     [nvarchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [PK_UpgradeInfo]
		PRIMARY KEY
		CLUSTERED
		([Item])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UpgradeInfo] SET (LOCK_ESCALATION = TABLE)
GO
