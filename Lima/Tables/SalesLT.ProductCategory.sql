SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesLT].[ProductCategory] (
		[ProductCategoryID]           [int] IDENTITY(1, 1) NOT NULL,
		[ParentProductCategoryID]     [int] NULL,
		[Name]                        [dbo].[Name] NOT NULL,
		[rowguid]                     [uniqueidentifier] NOT NULL,
		[ModifiedDate]                [datetime] NOT NULL,
		CONSTRAINT [AK_ProductCategory_Name]
		UNIQUE
		NONCLUSTERED
		([Name]),
		CONSTRAINT [AK_ProductCategory_rowguid]
		UNIQUE
		NONCLUSTERED
		([rowguid]),
		CONSTRAINT [PK_ProductCategory_ProductCategoryID]
		PRIMARY KEY
		CLUSTERED
		([ProductCategoryID])
)
GO
ALTER TABLE [SalesLT].[ProductCategory]
	ADD
	CONSTRAINT [DF_ProductCategory_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO
ALTER TABLE [SalesLT].[ProductCategory]
	ADD
	CONSTRAINT [DF_ProductCategory_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [SalesLT].[ProductCategory]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductCategory_ProductCategory_ParentProductCategoryID_ProductCategoryID]
	FOREIGN KEY ([ParentProductCategoryID]) REFERENCES [SalesLT].[ProductCategory] ([ProductCategoryID])
ALTER TABLE [SalesLT].[ProductCategory]
	CHECK CONSTRAINT [FK_ProductCategory_ProductCategory_ParentProductCategoryID_ProductCategoryID]

GO
ALTER TABLE [SalesLT].[ProductCategory] SET (LOCK_ESCALATION = TABLE)
GO
