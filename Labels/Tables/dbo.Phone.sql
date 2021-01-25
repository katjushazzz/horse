SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Phone] (
		[UserID]           [int] IDENTITY(1, 1) NOT NULL,
		[Name]             [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Surname]          [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Street]           [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[City]             [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Home_phone]       [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Mobile_phone]     [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [PK__Phone__1788CCAC1F3C8C85]
		PRIMARY KEY
		CLUSTERED
		([UserID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phone]
	ADD
	CONSTRAINT [DF__Phone__Home_phon__37A5467C]
	DEFAULT ('N/A') FOR [Home_phone]
GO
ALTER TABLE [dbo].[Phone]
	ADD
	CONSTRAINT [DF__Phone__Mobile_ph__38996AB5]
	DEFAULT ('N/A') FOR [Mobile_phone]
GO
ALTER TABLE [dbo].[Phone] SET (LOCK_ESCALATION = TABLE)
GO
