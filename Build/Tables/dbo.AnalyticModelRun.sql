SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AnalyticModelRun] (
		[AnalyticModelRunKey]        [int] NOT NULL,
		[AnalyticModelVersionID]     [int] NOT NULL,
		[StartTimeframeKey]          [int] NOT NULL,
		[EndTimeframeKey]            [int] NOT NULL,
		[ProductID]                  [int] NOT NULL,
		[RunDateTime]                [datetime2](7) NOT NULL,
		[SiteLevelFileName]          [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PatientLevelFileName]       [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[InformationFileName]        [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ControlFileName]            [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[RowIsCurrent]               [bit] NULL,
		[RowStartDate]               [datetime2](7) NULL,
		[RowEndDate]                 [datetime2](7) NULL,
		[ETLLogIDInsert]             [int] NULL,
		[ETLLogIDUpdate]             [int] NULL,
		[InsertTime]                 [datetime2](7) NULL,
		[UpdateTime]                 [datetime2](7) NULL,
		CONSTRAINT [PK_AnalyticModelRun]
		PRIMARY KEY
		CLUSTERED
		([AnalyticModelRunKey])
	ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_AnalyticModelRun_AnalyticModelVersion]
	ON [dbo].[AnalyticModelRun] ([AnalyticModelVersionID])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[AnalyticModelRun] SET (LOCK_ESCALATION = TABLE)
GO
