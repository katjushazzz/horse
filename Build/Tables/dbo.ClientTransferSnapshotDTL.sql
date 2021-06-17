SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[ClientTransferSnapshotDTL] (
		[AggregationKey]     [int] NOT NULL,
		[ClientKey]          [int] NOT NULL,
		[AHAFacilityID]      [int] NOT NULL,
		[ProductID]          [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientTransferSnapshotDTL] SET (LOCK_ESCALATION = TABLE)
GO
