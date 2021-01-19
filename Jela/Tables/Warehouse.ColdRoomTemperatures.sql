SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [Warehouse].[ColdRoomTemperatures] (
		[ColdRoomTemperatureID]     [bigint] IDENTITY(1, 1) NOT NULL,
		[ColdRoomSensorNumber]      [int] NOT NULL,
		[RecordedWhen]              [datetime2](7) NOT NULL,
		[Temperature]               [decimal](10, 2) NOT NULL,
		[ValidFrom]                 [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
		[ValidTo]                   [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
		PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo]),
		CONSTRAINT [PK_Warehouse_ColdRoomTemperatures]
		PRIMARY KEY
		NONCLUSTERED
		([ColdRoomTemperatureID])
	ON [PRIMARY]
) ON [PRIMARY]
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE=[Warehouse].[ColdRoomTemperatures_Archive]))
GO
CREATE NONCLUSTERED INDEX [IX_Warehouse_ColdRoomTemperatures_ColdRoomSensorNumber]
	ON [Warehouse].[ColdRoomTemperatures] ([ColdRoomSensorNumber])
	ON [PRIMARY]
GO
ALTER TABLE [Warehouse].[ColdRoomTemperatures] SET (LOCK_ESCALATION = TABLE)
GO
