SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesLT].[Product] (
		[ProductID]                  [int] IDENTITY(1, 1) NOT NULL,
		[Name]                       [dbo].[Name] NOT NULL,
		[ProductNumber]              [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Color]                      [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[StandardCost]               [money] NOT NULL,
		[ListPrice]                  [money] NOT NULL,
		[Size]                       [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Weight]                     [decimal](8, 2) NULL,
		[ProductCategoryID]          [int] NULL,
		[ProductModelID]             [int] NULL,
		[SellStartDate]              [datetime] NOT NULL,
		[SellEndDate]                [datetime] NULL,
		[DiscontinuedDate]           [datetime] NULL,
		[ThumbNailPhoto]             [varbinary](max) NULL,
		[ThumbnailPhotoFileName]     [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[rowguid]                    [uniqueidentifier] NOT NULL,
		[ModifiedDate]               [datetime] NOT NULL,
		CONSTRAINT [AK_Product_Name]
		UNIQUE
		NONCLUSTERED
		([Name]),
		CONSTRAINT [AK_Product_ProductNumber]
		UNIQUE
		NONCLUSTERED
		([ProductNumber]),
		CONSTRAINT [AK_Product_rowguid]
		UNIQUE
		NONCLUSTERED
		([rowguid]),
		CONSTRAINT [PK_Product_ProductID]
		PRIMARY KEY
		CLUSTERED
		([ProductID])
) TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [SalesLT].[Product]
	WITH NOCHECK
	ADD
	CONSTRAINT [CK_Product_ListPrice]
	CHECK
	/* Check constraint body could not be loaded because current user may have insufficient permissions */
GO
ALTER TABLE [SalesLT].[Product]
CHECK CONSTRAINT [CK_Product_ListPrice]
GO
ALTER TABLE [SalesLT].[Product]
	WITH NOCHECK
	ADD
	CONSTRAINT [CK_Product_SellEndDate]
	CHECK
	/* Check constraint body could not be loaded because current user may have insufficient permissions */
GO
ALTER TABLE [SalesLT].[Product]
CHECK CONSTRAINT [CK_Product_SellEndDate]
GO
ALTER TABLE [SalesLT].[Product]
	WITH NOCHECK
	ADD
	CONSTRAINT [CK_Product_StandardCost]
	CHECK
	/* Check constraint body could not be loaded because current user may have insufficient permissions */
GO
ALTER TABLE [SalesLT].[Product]
CHECK CONSTRAINT [CK_Product_StandardCost]
GO
ALTER TABLE [SalesLT].[Product]
	WITH NOCHECK
	ADD
	CONSTRAINT [CK_Product_Weight]
	CHECK
	/* Check constraint body could not be loaded because current user may have insufficient permissions */
GO
ALTER TABLE [SalesLT].[Product]
CHECK CONSTRAINT [CK_Product_Weight]
GO
ALTER TABLE [SalesLT].[Product]
	ADD
	CONSTRAINT [DF_Product_rowguid]
	DEFAULT  FOR [rowguid]
GO
ALTER TABLE [SalesLT].[Product]
	ADD
	CONSTRAINT [DF_Product_ModifiedDate]
	DEFAULT  FOR [ModifiedDate]
GO
ALTER TABLE [SalesLT].[Product]
	WITH CHECK
	ADD CONSTRAINT [FK_Product_ProductCategory_ProductCategoryID]
	FOREIGN KEY ([ProductCategoryID]) REFERENCES [SalesLT].[ProductCategory] ([ProductCategoryID])
ALTER TABLE [SalesLT].[Product]
	CHECK CONSTRAINT [FK_Product_ProductCategory_ProductCategoryID]

GO
ALTER TABLE [SalesLT].[Product]
	WITH CHECK
	ADD CONSTRAINT [FK_Product_ProductModel_ProductModelID]
	FOREIGN KEY ([ProductModelID]) REFERENCES [SalesLT].[ProductModel] ([ProductModelID])
ALTER TABLE [SalesLT].[Product]
	CHECK CONSTRAINT [FK_Product_ProductModel_ProductModelID]

GO
ALTER TABLE [SalesLT].[Product] SET (LOCK_ESCALATION = TABLE)
GO
