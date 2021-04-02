SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
--View [SalesLT].[vProductAndDescription] is encrypted. It could not be scripted
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE CLUSTERED INDEX [IX_vProductAndDescription]
	ON [SalesLT].[vProductAndDescription] ([Culture], [ProductID])
	ON [PRIMARY]
GO
