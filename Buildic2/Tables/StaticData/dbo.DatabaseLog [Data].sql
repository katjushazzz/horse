SET IDENTITY_INSERT [dbo].[DatabaseLog] ON
INSERT INTO [dbo].[DatabaseLog] ([DatabaseLogID], [PostTime], [DatabaseUser], [Event], [Schema], [Object], [TSQL], [XmlEvent]) VALUES (1, '20171027 14:33:01.390', N'dbo', N'CREATE_TABLE', N'dbo', N'ErrorLog', N'CREATE TABLE [dbo].[ErrorLog](
    [ErrorLogID] [int] IDENTITY (1, 1) NOT NULL,
    [ErrorTime] [datetime] NOT NULL CONSTRAINT [DF_ErrorLog_ErrorTime] DEFAULT (GETDATE()),
    [UserName] [sysname] NOT NULL, 
    [ErrorNumber] [int] NOT NULL, 
    [ErrorSeverity] [int] NULL, 
    [ErrorState] [int] NULL, 
    [ErrorProcedure] [nvarchar](126) NULL, 
    [ErrorLine] [int] NULL, 
    [ErrorMessage] [nvarchar](4000) NOT NULL
) ON [PRIMARY]', CONVERT([xml],N'<EVENT_INSTANCE><EventType>CREATE_TABLE</EventType><PostTime>2017-10-27T14:33:01.373</PostTime><SPID>56</SPID><ServerName>BARBKESS24\MSSQL2017RTM</ServerName><LoginName>REDMOND\barbkess</LoginName><UserName>dbo</UserName><DatabaseName>AdventureWorks2017</DatabaseName><SchemaName>dbo</SchemaName><ObjectName>ErrorLog</ObjectName><ObjectType>TABLE</ObjectType><TSQLCommand><SetOptions ANSI_NULLS="ON" ANSI_NULL_DEFAULT="ON" ANSI_PADDING="ON" QUOTED_IDENTIFIER="ON" ENCRYPTED="FALSE" /><CommandText>CREATE TABLE [dbo].[ErrorLog](
    [ErrorLogID] [int] IDENTITY (1, 1) NOT NULL,
    [ErrorTime] [datetime] NOT NULL CONSTRAINT [DF_ErrorLog_ErrorTime] DEFAULT (GETDATE()),
    [UserName] [sysname] NOT NULL, 
    [ErrorNumber] [int] NOT NULL, 
    [ErrorSeverity] [int] NULL, 
    [ErrorState] [int] NULL, 
    [ErrorProcedure] [nvarchar](126) NULL, 
    [ErrorLine] [int] NULL, 
    [ErrorMessage] [nvarchar](4000) NOT NULL
) ON [PRIMARY]</CommandText></TSQLCommand></EVENT_INSTANCE>',1))
INSERT INTO [dbo].[DatabaseLog] ([DatabaseLogID], [PostTime], [DatabaseUser], [Event], [Schema], [Object], [TSQL], [XmlEvent]) VALUES (2, '70171027 14:33:01.390', N'dbo', N'CREATE_TABLE', N'dbo', N'ErrorLog', N'CREATE TABLE [dbo].[ErrorLog](
    [ErrorLogID] [int] IDENTITY (1, 1) NOT NULL,
    [ErrorTime] [datetime] NOT NULL CONSTRAINT [DF_ErrorLog_ErrorTime] DEFAULT (GETDATE()),
    [UserName] [sysname] NOT NULL, 
    [ErrorNumber] [int] NOT NULL, 
    [ErrorSeverity] [int] NULL, 
    [ErrorState] [int] NULL, 
    [ErrorProcedure] [nvarchar](126) NULL, 
    [ErrorLine] [int] NULL, 
    [ErrorMessage] [nvarchar](4000) NOT NULL
) ON [PRIMARY]', CONVERT([xml],N'<EVENT_INSTANCE><EventType>CREATE_TABLE</EventType><PostTime>2017-10-27T14:33:01.373</PostTime><SPID>56</SPID><ServerName>BARBKESS24\MSSQL2017RTM</ServerName><LoginName>REDMOND\barbkess</LoginName><UserName>dbo</UserName><DatabaseName>AdventureWorks2017</DatabaseName><SchemaName>dbo</SchemaName><ObjectName>ErrorLog</ObjectName><ObjectType>TABLE</ObjectType><TSQLCommand><SetOptions ANSI_NULLS="ON" ANSI_NULL_DEFAULT="ON" ANSI_PADDING="ON" QUOTED_IDENTIFIER="ON" ENCRYPTED="FALSE" /><CommandText>CREATE TABLE [dbo].[ErrorLog](
    [ErrorLogID] [int] IDENTITY (1, 1) NOT NULL,
    [ErrorTime] [datetime] NOT NULL CONSTRAINT [DF_ErrorLog_ErrorTime] DEFAULT (GETDATE()),
    [UserName] [sysname] NOT NULL, 
    [ErrorNumber] [int] NOT NULL, 
    [ErrorSeverity] [int] NULL, 
    [ErrorState] [int] NULL, 
    [ErrorProcedure] [nvarchar](126) NULL, 
    [ErrorLine] [int] NULL, 
    [ErrorMessage] [nvarchar](4000) NOT NULL
) ON [PRIMARY]</CommandText></TSQLCommand></EVENT_INSTANCE>',1))
INSERT INTO [dbo].[DatabaseLog] ([DatabaseLogID], [PostTime], [DatabaseUser], [Event], [Schema], [Object], [TSQL], [XmlEvent]) VALUES (3, '41171027 14:33:01.390', N'dbo', N'CREATE_TABLE', N'dbo', N'ErrorLog', N'CREATE TABLE [dbo].[ErrorLog](
    [ErrorLogID] [int] IDENTITY (1, 1) NOT NULL,
    [ErrorTime] [datetime] NOT NULL CONSTRAINT [DF_ErrorLog_ErrorTime] DEFAULT (GETDATE()),
    [UserName] [sysname] NOT NULL, 
    [ErrorNumber] [int] NOT NULL, 
    [ErrorSeverity] [int] NULL, 
    [ErrorState] [int] NULL, 
    [ErrorProcedure] [nvarchar](126) NULL, 
    [ErrorLine] [int] NULL, 
    [ErrorMessage] [nvarchar](4000) NOT NULL
) ON [PRIMARY]', CONVERT([xml],N'<EVENT_INSTANCE><EventType>CREATE_TABLE</EventType><PostTime>2017-10-27T14:33:01.373</PostTime><SPID>56</SPID><ServerName>BARBKESS24\MSSQL2017RTM</ServerName><LoginName>REDMOND\barbkess</LoginName><UserName>dbo</UserName><DatabaseName>AdventureWorks2017</DatabaseName><SchemaName>dbo</SchemaName><ObjectName>ErrorLog</ObjectName><ObjectType>TABLE</ObjectType><TSQLCommand><SetOptions ANSI_NULLS="ON" ANSI_NULL_DEFAULT="ON" ANSI_PADDING="ON" QUOTED_IDENTIFIER="ON" ENCRYPTED="FALSE" /><CommandText>CREATE TABLE [dbo].[ErrorLog](
    [ErrorLogID] [int] IDENTITY (1, 1) NOT NULL,
    [ErrorTime] [datetime] NOT NULL CONSTRAINT [DF_ErrorLog_ErrorTime] DEFAULT (GETDATE()),
    [UserName] [sysname] NOT NULL, 
    [ErrorNumber] [int] NOT NULL, 
    [ErrorSeverity] [int] NULL, 
    [ErrorState] [int] NULL, 
    [ErrorProcedure] [nvarchar](126) NULL, 
    [ErrorLine] [int] NULL, 
    [ErrorMessage] [nvarchar](4000) NOT NULL
) ON [PRIMARY]</CommandText></TSQLCommand></EVENT_INSTANCE>',1))
SET IDENTITY_INSERT [dbo].[DatabaseLog] OFF
