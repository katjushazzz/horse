SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesLT].[ProductModelProductDescription] (
		[ProductModelID]           [int] NOT NULL,
		[ProductDescriptionID]     [int] NOT NULL,
		[Culture]                  [nchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[rowguid]                  [uniqueidentifier] NOT NULL,
		[ModifiedDate]             [datetime] NOT NULL,
		CONSTRAINT [AK_ProductModelProductDescription_rowguid]
		UNIQUE
		NONCLUSTERED
		([rowguid]),
		CONSTRAINT [PK_ProductModelProductDescription_ProductModelID_ProductDescriptionID_Culture]
		PRIMARY KEY
		CLUSTERED
		([ProductModelID], [ProductDescriptionID], [Culture])
)
GO
ALTER TABLE [SalesLT].[ProductModelProductDescription]
	ADD
	CONSTRAINT [DF_ProductModelProductDescription_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO
ALTER TABLE [SalesLT].[ProductModelProductDescription]
	ADD
	CONSTRAINT [DF_ProductModelProductDescription_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [SalesLT].[ProductModelProductDescription]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelProductDescription_ProductDescription_ProductDescriptionID]
	FOREIGN KEY ([ProductDescriptionID]) REFERENCES [SalesLT].[ProductDescription] ([ProductDescriptionID])
ALTER TABLE [SalesLT].[ProductModelProductDescription]
	CHECK CONSTRAINT [FK_ProductModelProductDescription_ProductDescription_ProductDescriptionID]

GO
ALTER TABLE [SalesLT].[ProductModelProductDescription]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelProductDescription_ProductModel_ProductModelID]
	FOREIGN KEY ([ProductModelID]) REFERENCES [SalesLT].[ProductModel] ([ProductModelID])
ALTER TABLE [SalesLT].[ProductModelProductDescription]
	CHECK CONSTRAINT [FK_ProductModelProductDescription_ProductModel_ProductModelID]

GO
ALTER TABLE [SalesLT].[ProductModelProductDescription] SET (LOCK_ESCALATION = TABLE)
GO
