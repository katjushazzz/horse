SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [SalesLT].[ProductDescription] (
		[ProductDescriptionID]     [int] IDENTITY(1, 1) NOT NULL,
		[Description]              [nvarchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[rowguid]                  [uniqueidentifier] NOT NULL,
		[ModifiedDate]             [datetime] NOT NULL,
		CONSTRAINT [AK_ProductDescription_rowguid]
		UNIQUE
		NONCLUSTERED
		([rowguid]),
		CONSTRAINT [PK_ProductDescription_ProductDescriptionID]
		PRIMARY KEY
		CLUSTERED
		([ProductDescriptionID])
)
GO
ALTER TABLE [SalesLT].[ProductDescription]
	ADD
	CONSTRAINT [DF_ProductDescription_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO
ALTER TABLE [SalesLT].[ProductDescription]
	ADD
	CONSTRAINT [DF_ProductDescription_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [SalesLT].[ProductDescription] SET (LOCK_ESCALATION = TABLE)
GO
