SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Warehouse].[ColdRoomTemperatures_Archive] (
		[ColdRoomTemperatureID]     [bigint] NOT NULL,
		[ColdRoomSensorNumber]      [int] NOT NULL,
		[RecordedWhen]              [datetime2](7) NOT NULL,
		[Temperature]               [decimal](10, 2) NOT NULL,
		[ValidFrom]                 [datetime2](7) NOT NULL,
		[ValidTo]                   [datetime2](7) NOT NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [ix_ColdRoomTemperatures_Archive]
	ON [Warehouse].[ColdRoomTemperatures_Archive] ([ValidTo], [ValidFrom])
	WITH ( 	DATA_COMPRESSION = PAGE)
	ON [PRIMARY]
GO
ALTER TABLE [Warehouse].[ColdRoomTemperatures_Archive] SET (LOCK_ESCALATION = TABLE)
GO
