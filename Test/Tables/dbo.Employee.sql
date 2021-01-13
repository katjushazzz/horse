SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Employee] (
		[Emp_ID]                  [int] IDENTITY(1, 1) NOT NULL,
		[Emp_First_Name]          [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Emp_Last_Name]           [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Emp_Date_Of_Birth]       [datetime] NULL,
		[Emp_Salary]              [int] NULL,
		[Emp_Email]               [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Emp_Employment_Date]     [datetime] NULL,
		CONSTRAINT [PK__Employee__2623598BB8368ADB]
		PRIMARY KEY
		CLUSTERED
		([Emp_ID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Employee] SET (LOCK_ESCALATION = TABLE)
GO
