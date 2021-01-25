SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Policies] (
		[PolicyID]       [uniqueidentifier] NOT NULL,
		[PolicyFlag]     [tinyint] NULL,
		CONSTRAINT [PK_Policies]
		PRIMARY KEY
		CLUSTERED
		([PolicyID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Policies] SET (LOCK_ESCALATION = TABLE)
GO
