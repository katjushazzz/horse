SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ComparisonGroupDIM] (
		[ComparisonGroupKey]       [int] NOT NULL,
		[ProductID]                [int] NULL,
		[ComparisonGroupName]      [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[ComparisonGroupDesc]      [varchar](7500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[ClientGroupKey]           [int] NULL,
		[ComparisonGroupType]      [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[LowerRange]               [int] NULL,
		[UpperRange]               [int] NULL,
		[ETLLogIDInsert]           [int] NOT NULL,
		[ETLLogIDUpdate]           [int] NOT NULL,
		[InsertTime]               [datetime] NOT NULL,
		[UpdateTime]               [datetime] NOT NULL,
		[RowIsCurrent]             [bit] NOT NULL,
		[RowStartDate]             [datetime] NOT NULL,
		[RowEndDate]               [datetime] NOT NULL,
		[ComparisonGroupLabel]     [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [ComparisonGroupDIM_PK]
		PRIMARY KEY
		CLUSTERED
		([ComparisonGroupKey])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ComparisonGroupDIM] SET (LOCK_ESCALATION = TABLE)
GO
