SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Nik1] (
		[UserID
]       [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Sid
]          [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[UserType
]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[AuthType
]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[UserName
]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Nik1] SET (LOCK_ESCALATION = TABLE)
GO
