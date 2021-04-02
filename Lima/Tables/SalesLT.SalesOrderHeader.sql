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
		[SalesOrderNumber]           AS (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID],(0)),N'*** ERROR ***')),
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
		[TotalDue]                   AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))),
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
	([DueDate]>=[OrderDate])
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_DueDate]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_Freight]
	CHECK
	([Freight]>=(0.00))
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_Freight]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_ShipDate]
	CHECK
	([ShipDate]>=[OrderDate] OR [ShipDate] IS NULL)
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_ShipDate]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_Status]
	CHECK
	([Status]>=(0) AND [Status]<=(8))
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_Status]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_SubTotal]
	CHECK
	([SubTotal]>=(0.00))
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_SubTotal]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_TaxAmt]
	CHECK
	([TaxAmt]>=(0.00))
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_TaxAmt]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_OrderID]
	DEFAULT (NEXT VALUE FOR [SalesLT].[SalesOrderNumber]) FOR [SalesOrderID]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_RevisionNumber]
	DEFAULT ((0)) FOR [RevisionNumber]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_OrderDate]
	DEFAULT (getdate()) FOR [OrderDate]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_Status]
	DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_OnlineOrderFlag]
	DEFAULT ((1)) FOR [OnlineOrderFlag]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_SubTotal]
	DEFAULT ((0.00)) FOR [SubTotal]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_TaxAmt]
	DEFAULT ((0.00)) FOR [TaxAmt]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_Freight]
	DEFAULT ((0.00)) FOR [Freight]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO
ALTER TABLE [SalesLT].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
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
