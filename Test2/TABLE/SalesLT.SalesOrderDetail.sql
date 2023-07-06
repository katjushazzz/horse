SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING OFF
GO
CREATE TABLE [SalesLT].[SalesOrderDetail] (
		[SalesOrderID]           [int] NOT NULL,
		[SalesOrderDetailID]     [int] IDENTITY(1, 1) NOT NULL,
		[OrderQty]               [smallint] NOT NULL,
		[ProductID]              [int] NOT NULL,
		[UnitPrice]              [money] NOT NULL,
		[UnitPriceDiscount]      [money] NOT NULL,
		[LineTotal]              [numeric](38, 6) NOT NULL,
		[rowguid]                [uniqueidentifier] NOT NULL,
		[ModifiedDate]           [datetime] NOT NULL,
		CONSTRAINT [AK_SalesOrderDetail_rowguid]
		UNIQUE
		NONCLUSTERED
		([rowguid]),
		CONSTRAINT [PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID]
		PRIMARY KEY
		CLUSTERED
		([SalesOrderID], [SalesOrderDetailID])
)
GO
ALTER TABLE [SalesLT].[SalesOrderDetail]
	WITH NOCHECK
	ADD
	CONSTRAINT [CK_SalesOrderDetail_OrderQty]
	CHECK
	/* Check constraint body could not be loaded because current user may have insufficient permissions */
GO
ALTER TABLE [SalesLT].[SalesOrderDetail]
CHECK CONSTRAINT [CK_SalesOrderDetail_OrderQty]
GO
ALTER TABLE [SalesLT].[SalesOrderDetail]
	WITH NOCHECK
	ADD
	CONSTRAINT [CK_SalesOrderDetail_UnitPrice]
	CHECK
	/* Check constraint body could not be loaded because current user may have insufficient permissions */
GO
ALTER TABLE [SalesLT].[SalesOrderDetail]
CHECK CONSTRAINT [CK_SalesOrderDetail_UnitPrice]
GO
ALTER TABLE [SalesLT].[SalesOrderDetail]
	WITH NOCHECK
	ADD
	CONSTRAINT [CK_SalesOrderDetail_UnitPriceDiscount]
	CHECK
	/* Check constraint body could not be loaded because current user may have insufficient permissions */
GO
ALTER TABLE [SalesLT].[SalesOrderDetail]
CHECK CONSTRAINT [CK_SalesOrderDetail_UnitPriceDiscount]
GO
ALTER TABLE [SalesLT].[SalesOrderDetail]
	ADD
	CONSTRAINT [DF_SalesOrderDetail_UnitPriceDiscount]
	DEFAULT  FOR [UnitPriceDiscount]
GO
ALTER TABLE [SalesLT].[SalesOrderDetail]
	ADD
	CONSTRAINT [DF_SalesOrderDetail_rowguid]
	DEFAULT  FOR [rowguid]
GO
ALTER TABLE [SalesLT].[SalesOrderDetail]
	ADD
	CONSTRAINT [DF_SalesOrderDetail_ModifiedDate]
	DEFAULT  FOR [ModifiedDate]
GO
ALTER TABLE [SalesLT].[SalesOrderDetail]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderDetail_Product_ProductID]
	FOREIGN KEY ([ProductID]) REFERENCES [SalesLT].[Product] ([ProductID])
ALTER TABLE [SalesLT].[SalesOrderDetail]
	CHECK CONSTRAINT [FK_SalesOrderDetail_Product_ProductID]

GO
ALTER TABLE [SalesLT].[SalesOrderDetail]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID]
	FOREIGN KEY ([SalesOrderID]) REFERENCES [SalesLT].[SalesOrderHeader] ([SalesOrderID])
	ON DELETE CASCADE
ALTER TABLE [SalesLT].[SalesOrderDetail]
	CHECK CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID]

GO
CREATE NONCLUSTERED INDEX [IX_SalesOrderDetail_ProductID]
	ON [SalesLT].[SalesOrderDetail] ([ProductID])
	ON [PRIMARY]
GO
ALTER TABLE [SalesLT].[SalesOrderDetail] SET (LOCK_ESCALATION = TABLE)
GO
