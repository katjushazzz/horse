SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesLT].[ProductModel] (
		[ProductModelID]         [int] IDENTITY(1, 1) NOT NULL,
		[Name]                   [dbo].[Name] NOT NULL,
		[CatalogDescription]     [xml] NULL,
		[rowguid]                [uniqueidentifier] NOT NULL,
		[ModifiedDate]           [datetime] NOT NULL,
		CONSTRAINT [AK_ProductModel_Name]
		UNIQUE
		NONCLUSTERED
		([Name]),
		CONSTRAINT [AK_ProductModel_rowguid]
		UNIQUE
		NONCLUSTERED
		([rowguid]),
		CONSTRAINT [PK_ProductModel_ProductModelID]
		PRIMARY KEY
		CLUSTERED
		([ProductModelID])
) TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [SalesLT].[ProductModel]
	ADD
	CONSTRAINT [DF_ProductModel_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO
ALTER TABLE [SalesLT].[ProductModel]
	ADD
	CONSTRAINT [DF_ProductModel_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [SalesLT].[ProductModel] SET (LOCK_ESCALATION = TABLE)
GO
