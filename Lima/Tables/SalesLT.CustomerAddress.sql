SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesLT].[CustomerAddress] (
		[CustomerID]       [int] NOT NULL,
		[AddressID]        [int] NOT NULL,
		[AddressType]      [dbo].[Name] NOT NULL,
		[rowguid]          [uniqueidentifier] NOT NULL,
		[ModifiedDate]     [datetime] NOT NULL,
		CONSTRAINT [AK_CustomerAddress_rowguid]
		UNIQUE
		NONCLUSTERED
		([rowguid]),
		CONSTRAINT [PK_CustomerAddress_CustomerID_AddressID]
		PRIMARY KEY
		CLUSTERED
		([CustomerID], [AddressID])
)
GO
ALTER TABLE [SalesLT].[CustomerAddress]
	ADD
	CONSTRAINT [DF_CustomerAddress_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO
ALTER TABLE [SalesLT].[CustomerAddress]
	ADD
	CONSTRAINT [DF_CustomerAddress_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [SalesLT].[CustomerAddress]
	WITH CHECK
	ADD CONSTRAINT [FK_CustomerAddress_Address_AddressID]
	FOREIGN KEY ([AddressID]) REFERENCES [SalesLT].[Address] ([AddressID])
ALTER TABLE [SalesLT].[CustomerAddress]
	CHECK CONSTRAINT [FK_CustomerAddress_Address_AddressID]

GO
ALTER TABLE [SalesLT].[CustomerAddress]
	WITH CHECK
	ADD CONSTRAINT [FK_CustomerAddress_Customer_CustomerID]
	FOREIGN KEY ([CustomerID]) REFERENCES [SalesLT].[Customer] ([CustomerID])
ALTER TABLE [SalesLT].[CustomerAddress]
	CHECK CONSTRAINT [FK_CustomerAddress_Customer_CustomerID]

GO
ALTER TABLE [SalesLT].[CustomerAddress] SET (LOCK_ESCALATION = TABLE)
GO
