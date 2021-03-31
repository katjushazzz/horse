SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesLT].[SalesOrderHeader] (
		[SalesOrderID]               [int] NOT NULL,
		[RevisionNumber]             [tinyint] NOT NULL,
		[OrderDate]                  [datetime] NOT NULL,
		[DueDate]                    [datetime] NOT NULL,
		[ShipDate]                   [datetime] NULL,
		[Status]                     [tinyint] NOT NULL,
		[OnlineOrderFlag]            [dbo].[Flag] NOT NULL,
		[SalesOrderNumber]           [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[PurchaseOrderNumber]        [dbo].[OrderNumber] NULL,
		[AccountNumber]              [dbo].[AccountNumber] NULL,
		[CustomerID]                 [int] NOT NULL,
		[ShipToAddressID]            [int] NULL,
		[BillToAddressID]            [int] NULL,
		[ShipMethod]                 [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[CreditCardApprovalCode]     [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[SubTotal]                   [money] NOT NULL,
		[TaxAmt]                     [money] NOT NULL,
		[Freight]                    [money] NOT NULL,
		[TotalDue]                   [money] NOT NULL,
		[Comment]                    [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[rowguid]                    [uniqueidentifier] NOT NULL,
		[ModifiedDate]               [datetime] NOT NULL,
		CONSTRAINT [AK_SalesOrderHeader_rowguid]
		UNIQUE
		NONCLUSTERED
		([rowguid]),
		CONSTRAINT [AK_SalesOrderHeader_SalesOrderNumber]
		UNIQUE
		NONCLUSTERED
		([SalesOrderNumber]),
		CONSTRAINT [PK_SalesOrderHeader_SalesOrderID]
		PRIMARY KEY
		CLUSTERED
		([SalesOrderID])
) TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_DueDate]
	CHECK
	/* Check constraint body could not be loaded because current user may have insufficient permissions */
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_DueDate]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_Freight]
	CHECK
	/* Check constraint body could not be loaded because current user may have insufficient permissions */
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_Freight]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_ShipDate]
	CHECK
	/* Check constraint body could not be loaded because current user may have insufficient permissions */
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_ShipDate]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_Status]
	CHECK
	/* Check constraint body could not be loaded because current user may have insufficient permissions */
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_Status]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_SubTotal]
	CHECK
	/* Check constraint body could not be loaded because current user may have insufficient permissions */
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_SubTotal]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_TaxAmt]
	CHECK
	/* Check constraint body could not be loaded because current user may have insufficient permissions */
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_TaxAmt]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_OrderID]
	DEFAULT  FOR [SalesOrderID]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_RevisionNumber]
	DEFAULT  FOR [RevisionNumber]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_OrderDate]
	DEFAULT  FOR [OrderDate]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_Status]
	DEFAULT  FOR [Status]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_OnlineOrderFlag]
	DEFAULT  FOR [OnlineOrderFlag]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_SubTotal]
	DEFAULT  FOR [SubTotal]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_TaxAmt]
	DEFAULT  FOR [TaxAmt]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_Freight]
	DEFAULT  FOR [Freight]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_rowguid]
	DEFAULT  FOR [rowguid]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_ModifiedDate]
	DEFAULT  FOR [ModifiedDate]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderHeader_Address_BillTo_AddressID]
	FOREIGN KEY ([BillToAddressID]) REFERENCES [SalesLT].[Address] ([AddressID])
ALTER TABLE [SalesLT].[SalesOrderHeader]
	CHECK CONSTRAINT [FK_SalesOrderHeader_Address_BillTo_AddressID]

GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderHeader_Address_ShipTo_AddressID]
	FOREIGN KEY ([ShipToAddressID]) REFERENCES [SalesLT].[Address] ([AddressID])
ALTER TABLE [SalesLT].[SalesOrderHeader]
	CHECK CONSTRAINT [FK_SalesOrderHeader_Address_ShipTo_AddressID]

GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderHeader_Customer_CustomerID]
	FOREIGN KEY ([CustomerID]) REFERENCES [SalesLT].[Customer] ([CustomerID])
ALTER TABLE [SalesLT].[SalesOrderHeader]
	CHECK CONSTRAINT [FK_SalesOrderHeader_Customer_CustomerID]

GO
CREATE NONCLUSTERED INDEX [IX_SalesOrderHeader_CustomerID]
	ON [SalesLT].[SalesOrderHeader] ([CustomerID])
	ON [PRIMARY]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader] SET (LOCK_ESCALATION = TABLE)
GO
