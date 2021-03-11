SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BuildVersion] (
		[SystemInformationID]     [tinyint] IDENTITY(1, 1) NOT NULL,
		[Database Version]        [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[VersionDate]             [datetime] NOT NULL,
		[ModifiedDate]            [datetime] NOT NULL,
		[Test]                    [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test2]                   [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test3]                   [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test4]                   [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [PK__BuildVer__35E58ECA3E3DE933]
		PRIMARY KEY
		CLUSTERED
		([SystemInformationID])
)
GO
ALTER TABLE [dbo].[BuildVersion]
	ADD
	CONSTRAINT [DF_BuildVersion_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[BuildVersion] SET (LOCK_ESCALATION = TABLE)
GO
