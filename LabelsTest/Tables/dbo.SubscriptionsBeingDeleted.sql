SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[SubscriptionsBeingDeleted] (
		[SubscriptionID]     [uniqueidentifier] NOT NULL,
		[CreationDate]       [datetime] NOT NULL,
		CONSTRAINT [PK_SubscriptionsBeingDeleted]
		PRIMARY KEY
		CLUSTERED
		([SubscriptionID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SubscriptionsBeingDeleted] SET (LOCK_ESCALATION = TABLE)
GO
