SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ClientAnalyticOutcomeFCT] (
		[AnalyticFactKey]               [bigint] NOT NULL,
		[AnalyticModelRunKey]           [int] NOT NULL,
		[ClientKey]                     [int] NOT NULL,
		[TimeframeKey]                  [int] NOT NULL,
		[RollingTimeframeInd]           [bit] NOT NULL,
		[AnalyticOutcomeID]             [int] NULL,
		[PopulationKey]                 [int] NULL,
		[Numerator]                     [float] NULL,
		[Denominator]                   [float] NULL,
		[Rate]                          [float] NULL,
		[RiskAdjustedRate]              [float] NULL,
		[ObservedEvent]                 [float] NULL,
		[ExpectedOutcome]               [float] NULL,
		[OERatio]                       [float] NULL,
		[StandardizedRate]              [float] NULL,
		[StandardizedRatio]             [float] NULL,
		[UpperCI]                       [float] NULL,
		[LowerCI]                       [float] NULL,
		[DenominatorExclusionCount]     [int] NULL,
		CONSTRAINT [UX_ClientAnalyticOutcomeFCT]
		UNIQUE
		NONCLUSTERED
		([ClientKey], [AnalyticOutcomeID], [PopulationKey], [AnalyticModelRunKey], [TimeframeKey], [RollingTimeframeInd])
		ON [PRIMARY],
		CONSTRAINT [PK_ClientAnalyticOutcomeFCT]
		PRIMARY KEY
		CLUSTERED
		([AnalyticModelRunKey], [AnalyticFactKey])
	ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ClientAnalyticOutcomeFCT_AnalyticModelRun]
	ON [dbo].[ClientAnalyticOutcomeFCT] ([AnalyticModelRunKey])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IXFK_ClientAnalyticOutcomeFCT_AnalyticOutcome]
	ON [dbo].[ClientAnalyticOutcomeFCT] ([AnalyticOutcomeID])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientAnalyticOutcomeFCT] SET (LOCK_ESCALATION = TABLE)
GO
