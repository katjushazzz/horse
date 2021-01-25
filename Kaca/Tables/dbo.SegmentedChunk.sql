SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SegmentedChunk] (
		[ChunkId]              [uniqueidentifier] NOT NULL,
		[SnapshotDataId]       [uniqueidentifier] NOT NULL,
		[ChunkFlags]           [tinyint] NOT NULL,
		[ChunkName]            [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[ChunkType]            [int] NOT NULL,
		[Version]              [smallint] NOT NULL,
		[MimeType]             [nvarchar](260) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[SegmentedChunkId]     [bigint] IDENTITY(1, 1) NOT NULL,
		CONSTRAINT [PK_SegmentedChunk]
		PRIMARY KEY
		CLUSTERED
		([SegmentedChunkId])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SegmentedChunk]
	ADD
	CONSTRAINT [DF_SegmentedChunk_ChunkId]
	DEFAULT (newsequentialid()) FOR [ChunkId]
GO
CREATE NONCLUSTERED INDEX [IX_ChunkId_SnapshotDataId]
	ON [dbo].[SegmentedChunk] ([ChunkId], [SnapshotDataId])
	ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UNIQ_SnapshotChunkMapping]
	ON [dbo].[SegmentedChunk] ([SnapshotDataId], [ChunkType], [ChunkName])
	INCLUDE ([ChunkId], [ChunkFlags])
	ON [PRIMARY]
GO
ALTER TABLE [dbo].[SegmentedChunk] SET (LOCK_ESCALATION = TABLE)
GO
