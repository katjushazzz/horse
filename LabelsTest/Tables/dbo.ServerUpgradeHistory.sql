SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ServerUpgradeHistory] (
		[UpgradeID]         [bigint] IDENTITY(1, 1) NOT NULL,
		[ServerVersion]     [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[User]              [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[DateTime]          [datetime] NULL,
		CONSTRAINT [PK_ServerUpgradeHistory]
		PRIMARY KEY
		CLUSTERED
		([UpgradeID] DESC)
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServerUpgradeHistory]
	ADD
	CONSTRAINT [DF__ServerUpg__DateT__1FEDB87C]
	DEFAULT (getdate()) FOR [DateTime]
GO
ALTER TABLE [dbo].[ServerUpgradeHistory]
	ADD
	CONSTRAINT [DF__ServerUpgr__User__1EF99443]
	DEFAULT (suser_sname()) FOR [User]
GO
ALTER TABLE [dbo].[ServerUpgradeHistory] SET (LOCK_ESCALATION = TABLE)
GO
