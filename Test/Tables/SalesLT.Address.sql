SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesLT].[Address] (
		[AddressID]         [int] IDENTITY(1, 1) NOT NULL,
		[AddressLine1]      [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[AddressLine2]      [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[City]              [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[StateProvince]     [dbo].[Name] NOT NULL,
		[CountryRegion]     [dbo].[Name] NOT NULL,
		[PostalCode]        [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[rowguid]           [uniqueidentifier] NOT NULL,
		[ModifiedDate]     [datetime] NOT NULL,
		CONSTRAINT [AK_Address_rowguid]
		UNIQUE
		NONCLUSTERED
		([rowguid]),
		CONSTRAINT [PK_Address_AddressID]
		PRIMARY KEY
		CLUSTERED
		([AddressID])
)
GO
ALTER TABLE [SalesLT].[Address]
	ADD
	CONSTRAINT [DF_Address_rowguid]
	DEFAULT  FOR [rowguid]
GO
ALTER TABLE [SalesLT].[Address]
	ADD
	CONSTRAINT [DF_Address_ModifiedDate]
	DEFAULT  FOR [ModifiedDate1]
GO
CREATE NONCLUSTERED INDEX [IX_Address_AddressLine1_AddressLine2_City_StateProvince_PostalCode_CountryRegion]
	ON [SalesLT].[Address] ([AddressLine1], [AddressLine2], [City], [StateProvince], [PostalCode], [CountryRegion])
	ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Address_StateProvince]
	ON [SalesLT].[Address] ([StateProvince])
	ON [PRIMARY]
GO
ALTER TABLE [SalesLT].[Address] SET (LOCK_ESCALATION = TABLE)
GO
