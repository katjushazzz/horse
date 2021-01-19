SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Snap] (
		[SnapshotDataID]        [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CreatedDate]           [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ParamsHash]            [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[QueryParams]           [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[EffectiveParams]       [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Description]           [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[DependsOnUser]         [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PermanentRefcount]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[TransientRefcount]     [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ExpirationDate]        [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PageCount]             [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[HasDocMap]             [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[PaginationMode]        [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[ProcessingFlags]       [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Snap] SET (LOCK_ESCALATION = TABLE)
GO
