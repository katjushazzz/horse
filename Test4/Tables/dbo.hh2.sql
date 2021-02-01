SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[hh2] (
		[Col1]          [int] NULL,
		[Col2]          [int] NULL,
		[FirstName]     [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS MASKED WITH (FUNCTION = 'email()') NULL,
		[LastName]      [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS MASKED WITH (FUNCTION = 'email()') NULL,
		[Name]          [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS MASKED WITH (FUNCTION = 'email()') NULL,
		[ime]           [nchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[prezime]       [nchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[hh2] SET (LOCK_ESCALATION = TABLE)
GO
