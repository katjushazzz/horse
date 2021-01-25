SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ServerParametersInstance] (
		[ServerParametersID]     [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[ParentID]               [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Path]                   [nvarchar](425) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[CreateDate]             [datetime] NOT NULL,
		[ModifiedDate]           [datetime] NOT NULL,
		[Timeout]                [int] NOT NULL,
		[Expiration]             [datetime] NOT NULL,
		[ParametersValues]       [image] NOT NULL,
		CONSTRAINT [PK_ServerParametersInstance]
		PRIMARY KEY
		CLUSTERED
		([ServerParametersID])
	ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ServerParametersInstanceExpiration]
	ON [dbo].[ServerParametersInstance] ([Expiration] DESC)
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServerParametersInstance] SET (LOCK_ESCALATION = TABLE)
GO
