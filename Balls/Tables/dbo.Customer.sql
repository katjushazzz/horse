SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customer] (
		[Customer_ID]            [int] IDENTITY(1, 1) NOT NULL,
		[First_Name]             [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS MASKED WITH (FUNCTION = 'default()') NULL,
		[Last_Name]              [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
		[Date_Of_Birth]          [datetime] MASKED WITH (FUNCTION = 'default()') NULL,
		[Montly_bill]            [int] MASKED WITH (FUNCTION = 'random(3, 9)') NULL,
		[Email]                  [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS MASKED WITH (FUNCTION = 'email()') NULL,
		[Credit_Card_Number]     [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS MASKED WITH (FUNCTION = 'partial(2, "x-xxx-xx", 2)') NULL,
		[Test]                   [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		[Test2]                  [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
		CONSTRAINT [PK__Customer__8CB286B9BE61F071]
		PRIMARY KEY
		CLUSTERED
		([Customer_ID])
	ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Customer] SET (LOCK_ESCALATION = TABLE)
GO
