SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ClientFacilitySnapshotDTL] (
		[AggregationKey]      [int] NOT NULL,
		[ClientKey]           [int] NOT NULL,
		[FacilityTypeKey]     [int] NULL,
		[FacilityKey]         [int] NULL,
		[ProductID]           [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientFacilitySnapshotDTL] SET (LOCK_ESCALATION = TABLE)
GO
