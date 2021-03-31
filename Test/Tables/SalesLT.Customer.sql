SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesLT].[Customer] (
		[CustomerID]       [int] IDENTITY(1, 1) NOT NULL,
		[NameStyle]        [dbo].[NameStyle] NOT NULL,
		[Title]            [nvarchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[FirstName]        [dbo].[Name] NOT NULL,
		[MiddleName]       [dbo].[Name] NULL,
		[LastName]         [dbo].[Name] NOT NULL,
		[Suffix]           [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[CompanyName]      [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[SalesPerson]      [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[EmailAddress]     [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Phone]            [dbo].[Phone] NULL,
		[PasswordHash]     [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[PasswordSalt]     [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[rowguid]          [uniqueidentifier] NOT NULL,
		[ModifiedDate]     [datetime] NOT NULL,
		CONSTRAINT [AK_Customer_rowguid]
		UNIQUE
		NONCLUSTERED
		([rowguid]),
		CONSTRAINT [PK_Customer_CustomerID]
		PRIMARY KEY
		CLUSTERED
		([CustomerID])
)
GO
ALTER TABLE [SalesLT].[Customer]
	ADD
	CONSTRAINT [DF_Customer_NameStyle]
	DEFAULT  FOR [NameStyle]
GO
ALTER TABLE [SalesLT].[Customer]
	ADD
	CONSTRAINT [DF_Customer_rowguid]
	DEFAULT  FOR [rowguid]
GO
ALTER TABLE [SalesLT].[Customer]
	ADD
	CONSTRAINT [DF_Customer_ModifiedDate]
	DEFAULT  FOR [ModifiedDate]
GO
CREATE NONCLUSTERED INDEX [IX_Customer_EmailAddress]
	ON [SalesLT].[Customer] ([EmailAddress])
	ON [PRIMARY]
GO
ALTER TABLE [SalesLT].[Customer] SET (LOCK_ESCALATION = TABLE)
GO
