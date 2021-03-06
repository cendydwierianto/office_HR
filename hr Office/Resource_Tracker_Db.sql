USE [master]
GO
/****** Object:  Database [trillion_hrappdb]    Script Date: 10/28/2019 6:58:04 PM ******/
CREATE DATABASE [trillion_hrappdb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'trillion_hrappdb', FILENAME = N'C:\Program Files (x86)\Plesk\Databases\MSSQL\MSSQL14.MSSQLSERVER2017\MSSQL\DATA\trillion_hrappdb.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'trillion_hrappdb_log', FILENAME = N'C:\Program Files (x86)\Plesk\Databases\MSSQL\MSSQL14.MSSQLSERVER2017\MSSQL\DATA\trillion_hrappdb_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [trillion_hrappdb] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [trillion_hrappdb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [trillion_hrappdb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET ARITHABORT OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [trillion_hrappdb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [trillion_hrappdb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [trillion_hrappdb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET  ENABLE_BROKER 
GO
ALTER DATABASE [trillion_hrappdb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [trillion_hrappdb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [trillion_hrappdb] SET  MULTI_USER 
GO
ALTER DATABASE [trillion_hrappdb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [trillion_hrappdb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [trillion_hrappdb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [trillion_hrappdb] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [trillion_hrappdb] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [trillion_hrappdb] SET QUERY_STORE = OFF
GO
USE [trillion_hrappdb]
GO
/****** Object:  User [trillion_hrappuser]    Script Date: 10/28/2019 6:58:09 PM ******/
CREATE USER [trillion_hrappuser] FOR LOGIN [trillion_hrappuser] WITH DEFAULT_SCHEMA=[trillion_hrappuser]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [trillion_hrappuser]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [trillion_hrappuser]
GO
ALTER ROLE [db_datareader] ADD MEMBER [trillion_hrappuser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [trillion_hrappuser]
GO
/****** Object:  Schema [trillion_hrappuser]    Script Date: 10/28/2019 6:58:09 PM ******/
CREATE SCHEMA [trillion_hrappuser]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 10/28/2019 6:58:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[Split]
(
    @String NVARCHAR(4000),
    @Delimiter NCHAR(1)
)
RETURNS TABLE
AS
RETURN
(
    WITH Split(stpos,endpos)
    AS(
        SELECT 0 AS stpos, CHARINDEX(@Delimiter,@String) AS endpos
        UNION ALL
        SELECT endpos+1, CHARINDEX(@Delimiter,@String,endpos+1)
            FROM Split
            WHERE endpos > 0
    )
    SELECT 'Id' = ROW_NUMBER() OVER (ORDER BY (SELECT 1)),
        'Data' = SUBSTRING(@String,stpos,COALESCE(NULLIF(endpos,0),LEN(@String)+1)-stpos)
    FROM Split
)




GO
/****** Object:  Table [dbo].[ResourceTracker_Attendance]    Script Date: 10/28/2019 6:58:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceTracker_Attendance](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[AttendanceDate] [date] NOT NULL,
	[CheckInTime] [datetime] NULL,
	[CheckOutTime] [datetime] NULL,
	[LessTimeReason] [nvarchar](150) NULL,
	[DailyWorkingTimeInMin] [int] NULL,
	[CompanyId] [int] NULL,
	[AllowOfficeLessTime] [int] NULL,
	[IsLeave] [bit] NULL,
 CONSTRAINT [PK_ResourceTracker_Attendance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourceTracker_Company]    Script Date: 10/28/2019 6:58:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceTracker_Company](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[PortalUserId] [nvarchar](128) NOT NULL,
	[CompanyName] [nvarchar](200) NOT NULL,
	[Address] [nvarchar](300) NULL,
	[PhoneNumber] [varchar](12) NOT NULL,
	[ImageFileName] [nvarchar](150) NULL,
	[ImageFileId] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[MaximumOfficeHours] [varchar](10) NULL,
	[OfficeOutTime] [varchar](10) NULL,
 CONSTRAINT [PK_ResourceTracker_Company] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourceTracker_Department]    Script Date: 10/28/2019 6:58:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceTracker_Department](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [int] NOT NULL,
	[DepartmentName] [nvarchar](150) NOT NULL,
	[CreatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourceTracker_EmployeeUser]    Script Date: 10/28/2019 6:58:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceTracker_EmployeeUser](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](30) NOT NULL,
	[Designation] [varchar](30) NOT NULL,
	[CompanyId] [int] NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[PhoneNumber] [varchar](12) NOT NULL,
	[ImageFileName] [nvarchar](200) NULL,
	[ImageFileId] [varchar](50) NULL,
	[UserId] [nvarchar](128) NULL,
	[IsAutoCheckPoint] [bit] NOT NULL,
	[AutoCheckPointTime] [varchar](10) NULL,
	[MaximumOfficeHours] [varchar](10) NULL,
	[OfficeOutTime] [varchar](10) NULL,
	[CreatedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourceTracker_LeaveApplication]    Script Date: 10/28/2019 6:58:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceTracker_LeaveApplication](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CompanyId] [int] NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[IsHalfDay] [bit] NULL,
	[LeaveTypeId] [int] NOT NULL,
	[LeaveReason] [nvarchar](150) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[IsApproved] [bit] NULL,
	[IsRejected] [bit] NULL,
	[RejectReason] [nvarchar](150) NULL,
	[ApprovedById] [uniqueidentifier] NULL,
	[ApprovedAt] [datetime] NULL,
 CONSTRAINT [PK_ResourceTracker_LeaveApplication] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourceTracker_NoticeBoard]    Script Date: 10/28/2019 6:58:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceTracker_NoticeBoard](
	[Id] [nvarchar](128) NOT NULL,
	[Details] [nvarchar](max) NULL,
	[PostingDate] [datetime] NOT NULL,
	[ImageFileName] [nvarchar](200) NULL,
	[CreatedBy] [nvarchar](128) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CompanyId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourceTracker_Task]    Script Date: 10/28/2019 6:58:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceTracker_Task](
	[Id] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](350) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[CreatedById] [uniqueidentifier] NULL,
	[CreatedAt] [datetime] NULL,
	[StatusId] [int] NULL,
	[TaskGroupId] [int] NULL,
	[AssignedToId] [uniqueidentifier] NULL,
	[DueDate] [datetime] NULL,
	[CompanyId] [int] NULL,
	[TaskNo] [int] NULL,
	[PriorityId] [int] NULL,
	[UpdatedById] [uniqueidentifier] NULL,
	[UpdatedAt] [datetime] NULL,
 CONSTRAINT [PK_ResourceTracker_Task] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourceTracker_TaskAttachments]    Script Date: 10/28/2019 6:58:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceTracker_TaskAttachments](
	[Id] [uniqueidentifier] NOT NULL,
	[TaskId] [uniqueidentifier] NOT NULL,
	[FileName] [nvarchar](150) NOT NULL,
	[BlobName] [nvarchar](50) NULL,
	[UpdatedAt] [datetime] NOT NULL,
	[UpdatedById] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ResourceTracker_TaskAttachments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourceTracker_TaskGroup]    Script Date: 10/28/2019 6:58:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceTracker_TaskGroup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[Description] [nvarchar](350) NULL,
	[BackGroundColor] [nvarchar](150) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedById] [uniqueidentifier] NULL,
	[CompanyId] [int] NULL,
 CONSTRAINT [PK_ResourceTracker_TaskGroup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourceTracker_ToDoTask]    Script Date: 10/28/2019 6:58:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceTracker_ToDoTask](
	[Id] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](350) NOT NULL,
	[Description] [nvarchar](350) NULL,
	[CreatedById] [uniqueidentifier] NULL,
	[CreatedAt] [datetime] NULL,
	[CompanyId] [int] NULL,
	[Completed] [bit] NOT NULL,
 CONSTRAINT [PK_ResourceTracker_ToTask] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourceTracker_ToDoTaskShare]    Script Date: 10/28/2019 6:58:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceTracker_ToDoTaskShare](
	[Id] [uniqueidentifier] NOT NULL,
	[TaskId] [uniqueidentifier] NOT NULL,
	[ShareWithId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ResourceTracker_ToDoTaskShare] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourceTracker_UserMovementLog]    Script Date: 10/28/2019 6:58:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceTracker_UserMovementLog](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[LogDateTime] [datetime] NOT NULL,
	[Latitude] [decimal](18, 10) NULL,
	[Longitude] [decimal](18, 10) NULL,
	[LogLocation] [nvarchar](150) NULL,
	[IsCheckInPoint] [bit] NULL,
	[IsCheckOutPoint] [bit] NULL,
	[DeviceName] [nvarchar](50) NULL,
	[DeviceOSVersion] [nvarchar](50) NULL,
	[CompanyId] [int] NULL,
 CONSTRAINT [PK_ResourceTracker_UserMovementLog] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserCredentials]    Script Date: 10/28/2019 6:58:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserCredentials](
	[Id] [uniqueidentifier] NOT NULL,
	[FullName] [nvarchar](350) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[ContactNo] [nvarchar](50) NOT NULL,
	[LoginID] [nvarchar](50) NULL,
	[Password] [nvarchar](50) NOT NULL,
	[UserTypeId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[Theme] [int] NULL,
	[OrganizationId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_UserCredentials] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[ResourceTracker_Attendance] ON 

INSERT [dbo].[ResourceTracker_Attendance] ([Id], [UserId], [AttendanceDate], [CheckInTime], [CheckOutTime], [LessTimeReason], [DailyWorkingTimeInMin], [CompanyId], [AllowOfficeLessTime], [IsLeave]) VALUES (1, N'82e07bcb-35a6-4619-a177-0ba08aaa66bc', CAST(N'2019-10-23' AS Date), CAST(N'2019-10-23T07:47:55.557' AS DateTime), NULL, NULL, 480, 1, 30, NULL)
INSERT [dbo].[ResourceTracker_Attendance] ([Id], [UserId], [AttendanceDate], [CheckInTime], [CheckOutTime], [LessTimeReason], [DailyWorkingTimeInMin], [CompanyId], [AllowOfficeLessTime], [IsLeave]) VALUES (2, N'c9404973-e5e5-4eb9-82fa-e769698b579a', CAST(N'2019-10-23' AS Date), CAST(N'2019-10-23T10:32:08.730' AS DateTime), CAST(N'2019-10-23T10:33:09.777' AS DateTime), NULL, 480, 1, 30, NULL)
INSERT [dbo].[ResourceTracker_Attendance] ([Id], [UserId], [AttendanceDate], [CheckInTime], [CheckOutTime], [LessTimeReason], [DailyWorkingTimeInMin], [CompanyId], [AllowOfficeLessTime], [IsLeave]) VALUES (3, N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', CAST(N'2019-10-23' AS Date), NULL, NULL, NULL, NULL, 1, NULL, 1)
INSERT [dbo].[ResourceTracker_Attendance] ([Id], [UserId], [AttendanceDate], [CheckInTime], [CheckOutTime], [LessTimeReason], [DailyWorkingTimeInMin], [CompanyId], [AllowOfficeLessTime], [IsLeave]) VALUES (4, N'c9404973-e5e5-4eb9-82fa-e769698b579a', CAST(N'2019-10-26' AS Date), CAST(N'2019-10-26T02:34:32.997' AS DateTime), NULL, NULL, 480, 1, 30, NULL)
INSERT [dbo].[ResourceTracker_Attendance] ([Id], [UserId], [AttendanceDate], [CheckInTime], [CheckOutTime], [LessTimeReason], [DailyWorkingTimeInMin], [CompanyId], [AllowOfficeLessTime], [IsLeave]) VALUES (5, N'f4bf2ddb-6448-42ec-bc6a-ae06d724446c', CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T12:57:41.423' AS DateTime), CAST(N'2019-10-27T12:58:00.797' AS DateTime), NULL, 480, 4, 30, NULL)
INSERT [dbo].[ResourceTracker_Attendance] ([Id], [UserId], [AttendanceDate], [CheckInTime], [CheckOutTime], [LessTimeReason], [DailyWorkingTimeInMin], [CompanyId], [AllowOfficeLessTime], [IsLeave]) VALUES (6, N'48bbf338-fe85-4da4-8aeb-f80eda4df816', CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T17:50:44.967' AS DateTime), NULL, NULL, 480, 5, 30, NULL)
INSERT [dbo].[ResourceTracker_Attendance] ([Id], [UserId], [AttendanceDate], [CheckInTime], [CheckOutTime], [LessTimeReason], [DailyWorkingTimeInMin], [CompanyId], [AllowOfficeLessTime], [IsLeave]) VALUES (7, N'061297b5-699d-44e5-ac81-b518569fca29', CAST(N'2019-10-27' AS Date), CAST(N'2019-10-27T17:54:05.483' AS DateTime), CAST(N'2019-10-27T17:55:25.813' AS DateTime), NULL, 480, 5, 30, NULL)
INSERT [dbo].[ResourceTracker_Attendance] ([Id], [UserId], [AttendanceDate], [CheckInTime], [CheckOutTime], [LessTimeReason], [DailyWorkingTimeInMin], [CompanyId], [AllowOfficeLessTime], [IsLeave]) VALUES (8, N'2ac7a9a2-4027-472d-b33a-402315c72614', CAST(N'2019-10-27' AS Date), NULL, NULL, NULL, NULL, 5, NULL, 1)
INSERT [dbo].[ResourceTracker_Attendance] ([Id], [UserId], [AttendanceDate], [CheckInTime], [CheckOutTime], [LessTimeReason], [DailyWorkingTimeInMin], [CompanyId], [AllowOfficeLessTime], [IsLeave]) VALUES (9, N'82e07bcb-35a6-4619-a177-0ba08aaa66bc', CAST(N'2019-10-28' AS Date), CAST(N'2019-10-28T11:01:34.163' AS DateTime), NULL, NULL, 480, 1, 30, NULL)
SET IDENTITY_INSERT [dbo].[ResourceTracker_Attendance] OFF
SET IDENTITY_INSERT [dbo].[ResourceTracker_Company] ON 

INSERT [dbo].[ResourceTracker_Company] ([Id], [PortalUserId], [CompanyName], [Address], [PhoneNumber], [ImageFileName], [ImageFileId], [CreatedDate], [MaximumOfficeHours], [OfficeOutTime]) VALUES (1, N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', N'Trillionbits', N'Shamoli Dhaka Bangladesh', N'01670959051', NULL, NULL, CAST(N'2019-10-23T07:17:52.480' AS DateTime), N'8:00:00', N'00:30:00')
INSERT [dbo].[ResourceTracker_Company] ([Id], [PortalUserId], [CompanyName], [Address], [PhoneNumber], [ImageFileName], [ImageFileId], [CreatedDate], [MaximumOfficeHours], [OfficeOutTime]) VALUES (2, N'a86d1b3d-b9fd-41c0-be56-ebdc3b888eab', N'4nesia', N'Jl Adhyaksa 3 No.26', N'081355147878', NULL, NULL, CAST(N'2019-10-26T16:21:44.623' AS DateTime), N'8:00:00', N'00:30:00')
INSERT [dbo].[ResourceTracker_Company] ([Id], [PortalUserId], [CompanyName], [Address], [PhoneNumber], [ImageFileName], [ImageFileId], [CreatedDate], [MaximumOfficeHours], [OfficeOutTime]) VALUES (3, N'f0e8c5d0-bbbb-46d4-bbdd-46f701410864', N'at', N'green park', N'123456', NULL, NULL, CAST(N'2019-10-27T03:38:46.180' AS DateTime), N'8:00:00', N'00:30:00')
INSERT [dbo].[ResourceTracker_Company] ([Id], [PortalUserId], [CompanyName], [Address], [PhoneNumber], [ImageFileName], [ImageFileId], [CreatedDate], [MaximumOfficeHours], [OfficeOutTime]) VALUES (4, N'334b9eab-e5ee-4db7-8f1a-99728bd671a0', N'Ghdltd', N'Ggd', N'528', NULL, NULL, CAST(N'2019-10-27T12:07:47.453' AS DateTime), N'8:00:00', N'00:30:00')
INSERT [dbo].[ResourceTracker_Company] ([Id], [PortalUserId], [CompanyName], [Address], [PhoneNumber], [ImageFileName], [ImageFileId], [CreatedDate], [MaximumOfficeHours], [OfficeOutTime]) VALUES (5, N'2ac7a9a2-4027-472d-b33a-402315c72614', N'Test', N'Gshe ', N'8923', NULL, NULL, CAST(N'2019-10-27T14:13:53.063' AS DateTime), N'8:00:00', N'00:30:00')
SET IDENTITY_INSERT [dbo].[ResourceTracker_Company] OFF
SET IDENTITY_INSERT [dbo].[ResourceTracker_Department] ON 

INSERT [dbo].[ResourceTracker_Department] ([Id], [CompanyId], [DepartmentName], [CreatedDate]) VALUES (1, 1, N'Development', NULL)
INSERT [dbo].[ResourceTracker_Department] ([Id], [CompanyId], [DepartmentName], [CreatedDate]) VALUES (2, 1, N'HR', NULL)
INSERT [dbo].[ResourceTracker_Department] ([Id], [CompanyId], [DepartmentName], [CreatedDate]) VALUES (3, 1, N'Accounts', NULL)
INSERT [dbo].[ResourceTracker_Department] ([Id], [CompanyId], [DepartmentName], [CreatedDate]) VALUES (4, 0, N'Chief', NULL)
INSERT [dbo].[ResourceTracker_Department] ([Id], [CompanyId], [DepartmentName], [CreatedDate]) VALUES (5, 4, N'Tw', NULL)
INSERT [dbo].[ResourceTracker_Department] ([Id], [CompanyId], [DepartmentName], [CreatedDate]) VALUES (6, 0, N'Tes', NULL)
INSERT [dbo].[ResourceTracker_Department] ([Id], [CompanyId], [DepartmentName], [CreatedDate]) VALUES (7, 5, N'Tt', NULL)
SET IDENTITY_INSERT [dbo].[ResourceTracker_Department] OFF
SET IDENTITY_INSERT [dbo].[ResourceTracker_EmployeeUser] ON 

INSERT [dbo].[ResourceTracker_EmployeeUser] ([Id], [UserName], [Designation], [CompanyId], [DepartmentId], [PhoneNumber], [ImageFileName], [ImageFileId], [UserId], [IsAutoCheckPoint], [AutoCheckPointTime], [MaximumOfficeHours], [OfficeOutTime], [CreatedDate], [IsActive]) VALUES (1, N'Tajuddin', N'Software Engineer', 1, 1, N'01916387657', NULL, NULL, N'c9404973-e5e5-4eb9-82fa-e769698b579a', 0, N'1:00:00', N'8:00:00', N'00:30:00', NULL, 1)
INSERT [dbo].[ResourceTracker_EmployeeUser] ([Id], [UserName], [Designation], [CompanyId], [DepartmentId], [PhoneNumber], [ImageFileName], [ImageFileId], [UserId], [IsAutoCheckPoint], [AutoCheckPointTime], [MaximumOfficeHours], [OfficeOutTime], [CreatedDate], [IsActive]) VALUES (2, N'Abu Hasan', N'Sr. Software Engineer', 1, 1, N'01736659047', NULL, NULL, N'82e07bcb-35a6-4619-a177-0ba08aaa66bc', 0, N'1:00:00', N'8:00:00', N'00:30:00', NULL, 1)
INSERT [dbo].[ResourceTracker_EmployeeUser] ([Id], [UserName], [Designation], [CompanyId], [DepartmentId], [PhoneNumber], [ImageFileName], [ImageFileId], [UserId], [IsAutoCheckPoint], [AutoCheckPointTime], [MaximumOfficeHours], [OfficeOutTime], [CreatedDate], [IsActive]) VALUES (3, N'Amin Sharif', N'Developer', 1, 1, N'01726324631', NULL, NULL, N'3792b1d6-04a5-4ee8-a098-56273d00c40a', 0, N'1:00:00', N'8:00:00', N'00:30:00', NULL, 1)
INSERT [dbo].[ResourceTracker_EmployeeUser] ([Id], [UserName], [Designation], [CompanyId], [DepartmentId], [PhoneNumber], [ImageFileName], [ImageFileId], [UserId], [IsAutoCheckPoint], [AutoCheckPointTime], [MaximumOfficeHours], [OfficeOutTime], [CreatedDate], [IsActive]) VALUES (4, N'Ripon', N'Sr Software Engineer ', 1, 1, N'01736659048', NULL, NULL, N'494fbf63-a1c9-4e2d-b205-36939b6ca36e', 0, N'1:00:00', N'8:00:00', N'00:30:00', NULL, 1)
INSERT [dbo].[ResourceTracker_EmployeeUser] ([Id], [UserName], [Designation], [CompanyId], [DepartmentId], [PhoneNumber], [ImageFileName], [ImageFileId], [UserId], [IsAutoCheckPoint], [AutoCheckPointTime], [MaximumOfficeHours], [OfficeOutTime], [CreatedDate], [IsActive]) VALUES (5, N'tfg', N'Yg', 4, 5, N'55865', NULL, NULL, N'8388ec92-ff00-4868-828d-6fc368239f67', 0, N'1:00:00', N'8:00:00', N'00:30:00', NULL, 1)
INSERT [dbo].[ResourceTracker_EmployeeUser] ([Id], [UserName], [Designation], [CompanyId], [DepartmentId], [PhoneNumber], [ImageFileName], [ImageFileId], [UserId], [IsAutoCheckPoint], [AutoCheckPointTime], [MaximumOfficeHours], [OfficeOutTime], [CreatedDate], [IsActive]) VALUES (6, N'ram', N'Ga', 4, 5, N'354', NULL, NULL, N'1048519d-c50d-467c-af6e-75beee0cce48', 0, N'1:00:00', N'8:00:00', N'00:30:00', NULL, 1)
INSERT [dbo].[ResourceTracker_EmployeeUser] ([Id], [UserName], [Designation], [CompanyId], [DepartmentId], [PhoneNumber], [ImageFileName], [ImageFileId], [UserId], [IsAutoCheckPoint], [AutoCheckPointTime], [MaximumOfficeHours], [OfficeOutTime], [CreatedDate], [IsActive]) VALUES (7, N'ram', N'Bshd', 4, 5, N'6464', NULL, NULL, N'f4bf2ddb-6448-42ec-bc6a-ae06d724446c', 1, N'1:00:00', N'8:00:00', N'00:30:00', NULL, 1)
INSERT [dbo].[ResourceTracker_EmployeeUser] ([Id], [UserName], [Designation], [CompanyId], [DepartmentId], [PhoneNumber], [ImageFileName], [ImageFileId], [UserId], [IsAutoCheckPoint], [AutoCheckPointTime], [MaximumOfficeHours], [OfficeOutTime], [CreatedDate], [IsActive]) VALUES (8, N'tt', N'Yy', 5, 7, N'2223', N'', N'', N'061297b5-699d-44e5-ac81-b518569fca29', 0, N'1:00:00', N'8:00:00', N'00:30:00', NULL, 1)
INSERT [dbo].[ResourceTracker_EmployeeUser] ([Id], [UserName], [Designation], [CompanyId], [DepartmentId], [PhoneNumber], [ImageFileName], [ImageFileId], [UserId], [IsAutoCheckPoint], [AutoCheckPointTime], [MaximumOfficeHours], [OfficeOutTime], [CreatedDate], [IsActive]) VALUES (9, N'tr', N'Hs', 5, 7, N'96698', NULL, NULL, N'48bbf338-fe85-4da4-8aeb-f80eda4df816', 1, N'1:00:00', N'8:00:00', N'00:30:00', NULL, 1)
SET IDENTITY_INSERT [dbo].[ResourceTracker_EmployeeUser] OFF
SET IDENTITY_INSERT [dbo].[ResourceTracker_LeaveApplication] ON 

INSERT [dbo].[ResourceTracker_LeaveApplication] ([Id], [CompanyId], [EmployeeId], [FromDate], [ToDate], [IsHalfDay], [LeaveTypeId], [LeaveReason], [CreatedAt], [IsApproved], [IsRejected], [RejectReason], [ApprovedById], [ApprovedAt]) VALUES (1, 1, 1, CAST(N'2019-10-23T17:34:22.000' AS DateTime), CAST(N'2019-10-23T17:34:22.000' AS DateTime), 0, 1, N'Holiday to singapore', CAST(N'2019-10-23T10:34:48.000' AS DateTime), 1, 0, N'', N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', CAST(N'2019-10-23T10:44:49.040' AS DateTime))
INSERT [dbo].[ResourceTracker_LeaveApplication] ([Id], [CompanyId], [EmployeeId], [FromDate], [ToDate], [IsHalfDay], [LeaveTypeId], [LeaveReason], [CreatedAt], [IsApproved], [IsRejected], [RejectReason], [ApprovedById], [ApprovedAt]) VALUES (2, 1, 1, CAST(N'2019-10-28T00:00:00.000' AS DateTime), CAST(N'2019-10-28T00:00:00.000' AS DateTime), 0, 2, N'I got fever', CAST(N'2019-10-26T02:36:01.000' AS DateTime), 0, 0, N'', NULL, NULL)
INSERT [dbo].[ResourceTracker_LeaveApplication] ([Id], [CompanyId], [EmployeeId], [FromDate], [ToDate], [IsHalfDay], [LeaveTypeId], [LeaveReason], [CreatedAt], [IsApproved], [IsRejected], [RejectReason], [ApprovedById], [ApprovedAt]) VALUES (3, 4, 7, CAST(N'2019-10-29T00:00:00.000' AS DateTime), CAST(N'2019-10-30T00:00:00.000' AS DateTime), 0, 2, N'hdhe', CAST(N'2019-10-27T12:56:27.000' AS DateTime), 0, 0, N'', NULL, NULL)
INSERT [dbo].[ResourceTracker_LeaveApplication] ([Id], [CompanyId], [EmployeeId], [FromDate], [ToDate], [IsHalfDay], [LeaveTypeId], [LeaveReason], [CreatedAt], [IsApproved], [IsRejected], [RejectReason], [ApprovedById], [ApprovedAt]) VALUES (4, 5, 9, CAST(N'2019-10-28T00:00:00.000' AS DateTime), CAST(N'2019-10-31T00:00:00.000' AS DateTime), 0, 2, N'ye', CAST(N'2019-10-27T17:50:11.000' AS DateTime), 1, 0, N'', N'2ac7a9a2-4027-472d-b33a-402315c72614', CAST(N'2019-10-27T17:58:24.797' AS DateTime))
INSERT [dbo].[ResourceTracker_LeaveApplication] ([Id], [CompanyId], [EmployeeId], [FromDate], [ToDate], [IsHalfDay], [LeaveTypeId], [LeaveReason], [CreatedAt], [IsApproved], [IsRejected], [RejectReason], [ApprovedById], [ApprovedAt]) VALUES (5, 1, 2, CAST(N'2019-10-30T00:00:00.000' AS DateTime), CAST(N'2019-10-30T00:00:00.000' AS DateTime), 0, 1, N'I need urgently leave.', CAST(N'2019-10-28T11:04:18.000' AS DateTime), 0, 0, N'', NULL, NULL)
SET IDENTITY_INSERT [dbo].[ResourceTracker_LeaveApplication] OFF
INSERT [dbo].[ResourceTracker_NoticeBoard] ([Id], [Details], [PostingDate], [ImageFileName], [CreatedBy], [CreateDate], [CompanyId]) VALUES (N'13440ee1-32d4-4e9c-9662-fb2a51e4f28e', N'Tomorrow holiday', CAST(N'2019-10-28T10:59:30.803' AS DateTime), N'', N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', CAST(N'2019-10-28T10:59:30.803' AS DateTime), 1)
INSERT [dbo].[ResourceTracker_NoticeBoard] ([Id], [Details], [PostingDate], [ImageFileName], [CreatedBy], [CreateDate], [CompanyId]) VALUES (N'2a081f00-fa4b-45c7-bed9-7c303a0d1549', N'Sjsnbs', CAST(N'2019-10-28T06:40:36.867' AS DateTime), N'', N'c9fb99c2-51e1-4a77-ae0f-de59b6c90c07', CAST(N'2019-10-28T06:40:36.867' AS DateTime), 0)
INSERT [dbo].[ResourceTracker_NoticeBoard] ([Id], [Details], [PostingDate], [ImageFileName], [CreatedBy], [CreateDate], [CompanyId]) VALUES (N'2fee5201-7627-42bb-be23-61d9edd6278f', N'Tajuddin is taking leave from 23-Oct-2019 to 23-Oct-2019.', CAST(N'2019-10-23T10:44:49.057' AS DateTime), NULL, N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', CAST(N'2019-10-23T10:44:49.057' AS DateTime), 1)
INSERT [dbo].[ResourceTracker_NoticeBoard] ([Id], [Details], [PostingDate], [ImageFileName], [CreatedBy], [CreateDate], [CompanyId]) VALUES (N'3ca2d103-67ad-4922-8276-8835b8a9434a', N'The best place to take holiday', CAST(N'2019-10-23T10:43:57.027' AS DateTime), N'fb095641-82d1-4fc3-97cc-59dd3b5ac604.jpg', N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', CAST(N'2019-10-23T10:43:57.027' AS DateTime), 1)
INSERT [dbo].[ResourceTracker_NoticeBoard] ([Id], [Details], [PostingDate], [ImageFileName], [CreatedBy], [CreateDate], [CompanyId]) VALUES (N'698d3095-6196-4374-9a1b-6fb0a2bb935c', N'tr is taking leave from 28-Oct-2019 to 31-Oct-2019.', CAST(N'2019-10-27T17:58:24.797' AS DateTime), NULL, N'2ac7a9a2-4027-472d-b33a-402315c72614', CAST(N'2019-10-27T17:58:24.797' AS DateTime), 5)
INSERT [dbo].[ResourceTracker_NoticeBoard] ([Id], [Details], [PostingDate], [ImageFileName], [CreatedBy], [CreateDate], [CompanyId]) VALUES (N'791c96f1-58e7-4d5b-9c17-8c07eb134850', N'Hi', CAST(N'2019-10-27T12:41:43.407' AS DateTime), N'', N'334b9eab-e5ee-4db7-8f1a-99728bd671a0', CAST(N'2019-10-27T12:41:43.407' AS DateTime), 4)
INSERT [dbo].[ResourceTracker_NoticeBoard] ([Id], [Details], [PostingDate], [ImageFileName], [CreatedBy], [CreateDate], [CompanyId]) VALUES (N'c4d06219-b1bd-454b-b6a2-f10d2a06be30', N'Bs', CAST(N'2019-10-27T12:57:18.783' AS DateTime), N'9558745f-d2c5-4d89-8bbc-f7ed5af471e3.jpg', N'f4bf2ddb-6448-42ec-bc6a-ae06d724446c', CAST(N'2019-10-27T12:57:18.783' AS DateTime), 4)
INSERT [dbo].[ResourceTracker_NoticeBoard] ([Id], [Details], [PostingDate], [ImageFileName], [CreatedBy], [CreateDate], [CompanyId]) VALUES (N'd9686159-7cdb-4e40-b7bf-090bb6d05c80', N'Hhshe
', CAST(N'2019-10-27T12:11:14.140' AS DateTime), N'', N'334b9eab-e5ee-4db7-8f1a-99728bd671a0', CAST(N'2019-10-27T12:11:14.140' AS DateTime), 4)
INSERT [dbo].[ResourceTracker_Task] ([Id], [Title], [Description], [CreatedById], [CreatedAt], [StatusId], [TaskGroupId], [AssignedToId], [DueDate], [CompanyId], [TaskNo], [PriorityId], [UpdatedById], [UpdatedAt]) VALUES (N'27749833-919c-4eda-b628-2aa2f30351f0', N'Deliver Parcel', N'Deliver percell to client', N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', CAST(N'2019-10-28T10:53:53.883' AS DateTime), 1, NULL, N'82e07bcb-35a6-4619-a177-0ba08aaa66bc', CAST(N'2019-10-28T00:00:00.000' AS DateTime), 1, 3, 2, NULL, NULL)
INSERT [dbo].[ResourceTracker_Task] ([Id], [Title], [Description], [CreatedById], [CreatedAt], [StatusId], [TaskGroupId], [AssignedToId], [DueDate], [CompanyId], [TaskNo], [PriorityId], [UpdatedById], [UpdatedAt]) VALUES (N'c9bfd785-1d20-4a90-bb3b-3491d30e59b9', N'Meet to client', N'Meet to our client Mr. Sharif', N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', CAST(N'2019-10-28T10:54:45.163' AS DateTime), 1, NULL, N'c9404973-e5e5-4eb9-82fa-e769698b579a', CAST(N'2019-10-29T00:00:00.000' AS DateTime), 1, 4, 2, NULL, NULL)
INSERT [dbo].[ResourceTracker_Task] ([Id], [Title], [Description], [CreatedById], [CreatedAt], [StatusId], [TaskGroupId], [AssignedToId], [DueDate], [CompanyId], [TaskNo], [PriorityId], [UpdatedById], [UpdatedAt]) VALUES (N'0c5b1a44-ce2f-4250-b2dd-3a2877dc9cf0', N'test', N'Tedf', N'82e07bcb-35a6-4619-a177-0ba08aaa66bc', CAST(N'2019-10-27T12:48:04.997' AS DateTime), 1, NULL, N'3792b1d6-04a5-4ee8-a098-56273d00c40a', CAST(N'2019-10-31T00:00:00.000' AS DateTime), 1, 2, 3, NULL, NULL)
INSERT [dbo].[ResourceTracker_Task] ([Id], [Title], [Description], [CreatedById], [CreatedAt], [StatusId], [TaskGroupId], [AssignedToId], [DueDate], [CompanyId], [TaskNo], [PriorityId], [UpdatedById], [UpdatedAt]) VALUES (N'd8f48f9b-e84f-448b-8a3a-4c1df9be1b39', N'teat', N'Test', N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', CAST(N'2019-10-27T12:09:47.107' AS DateTime), 1, NULL, N'82e07bcb-35a6-4619-a177-0ba08aaa66bc', NULL, 1, 1, 2, NULL, NULL)
INSERT [dbo].[ResourceTracker_Task] ([Id], [Title], [Description], [CreatedById], [CreatedAt], [StatusId], [TaskGroupId], [AssignedToId], [DueDate], [CompanyId], [TaskNo], [PriorityId], [UpdatedById], [UpdatedAt]) VALUES (N'2d21924d-3ff5-4b88-b8f4-c200bfc47901', N'Receive item', N'Receive item', N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', CAST(N'2019-10-28T10:55:31.087' AS DateTime), 1, NULL, N'3792b1d6-04a5-4ee8-a098-56273d00c40a', CAST(N'2019-10-30T00:00:00.000' AS DateTime), 1, 5, 1, NULL, NULL)
SET IDENTITY_INSERT [dbo].[ResourceTracker_TaskGroup] ON 

INSERT [dbo].[ResourceTracker_TaskGroup] ([Id], [Name], [Description], [BackGroundColor], [CreatedAt], [CreatedById], [CompanyId]) VALUES (1, N'Test', NULL, N'#5a7fbf', CAST(N'2019-10-27T11:46:10.660' AS DateTime), N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', 1)
INSERT [dbo].[ResourceTracker_TaskGroup] ([Id], [Name], [Description], [BackGroundColor], [CreatedAt], [CreatedById], [CompanyId]) VALUES (2, N'Martketing', NULL, N'#4899d6', CAST(N'2019-10-28T10:56:17.897' AS DateTime), N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', 1)
INSERT [dbo].[ResourceTracker_TaskGroup] ([Id], [Name], [Description], [BackGroundColor], [CreatedAt], [CreatedById], [CompanyId]) VALUES (3, N'Development', NULL, N'#106d85', CAST(N'2019-10-28T10:57:16.477' AS DateTime), N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', 1)
INSERT [dbo].[ResourceTracker_TaskGroup] ([Id], [Name], [Description], [BackGroundColor], [CreatedAt], [CreatedById], [CompanyId]) VALUES (4, N'Hr', NULL, N'#106d85', CAST(N'2019-10-28T10:57:24.443' AS DateTime), N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', 1)
INSERT [dbo].[ResourceTracker_TaskGroup] ([Id], [Name], [Description], [BackGroundColor], [CreatedAt], [CreatedById], [CompanyId]) VALUES (5, N'Accounts', NULL, N'#13598f', CAST(N'2019-10-28T10:57:37.287' AS DateTime), N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', 1)
SET IDENTITY_INSERT [dbo].[ResourceTracker_TaskGroup] OFF
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'9c11ef9e-2ab5-4602-9866-02b1d4b628e1', N'c9404973-e5e5-4eb9-82fa-e769698b579a', CAST(N'2019-10-23T10:33:09.777' AS DateTime), CAST(-6.3223908000 AS Decimal(18, 10)), CAST(107.0520366000 AS Decimal(18, 10)), N'null, Kecamatan Setu, Indonesia', NULL, 1, NULL, N'26', 1)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'dc7cf861-b30a-4ae5-8a3a-078a42560ee0', N'061297b5-699d-44e5-ac81-b518569fca29', CAST(N'2019-10-27T17:55:12.373' AS DateTime), CAST(23.4074361000 AS Decimal(18, 10)), CAST(88.3605674000 AS Decimal(18, 10)), N'Sarkarpara Lane, Nabadwip, India', NULL, NULL, NULL, N'24', 5)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'561c161b-00b1-4e64-9a32-1455aefb1771', N'f4bf2ddb-6448-42ec-bc6a-ae06d724446c', CAST(N'2019-10-27T12:57:41.423' AS DateTime), CAST(23.4118151000 AS Decimal(18, 10)), CAST(88.3621504000 AS Decimal(18, 10)), N'Buroshib Tala Road, Nabadwip, India', 1, NULL, NULL, N'24', 4)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'cbe24782-40aa-4c9a-9151-2305a97371b6', N'c9404973-e5e5-4eb9-82fa-e769698b579a', CAST(N'2019-10-23T10:32:08.743' AS DateTime), CAST(-6.3223908000 AS Decimal(18, 10)), CAST(107.0520366000 AS Decimal(18, 10)), N'null, Kecamatan Setu, Indonesia', 1, NULL, NULL, N'26', 1)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'882fa96f-d64f-424c-9df9-28d230e6d0af', N'061297b5-699d-44e5-ac81-b518569fca29', CAST(N'2019-10-27T17:55:20.157' AS DateTime), CAST(23.4074361000 AS Decimal(18, 10)), CAST(88.3605674000 AS Decimal(18, 10)), N'Sarkarpara Lane, Nabadwip, India', NULL, NULL, NULL, N'24', 5)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'a2f6863e-daf1-4984-aa1d-2e1ae40a8297', N'82e07bcb-35a6-4619-a177-0ba08aaa66bc', CAST(N'2019-10-23T07:47:55.573' AS DateTime), CAST(23.7723400000 AS Decimal(18, 10)), CAST(90.3644985000 AS Decimal(18, 10)), N'Khilji Road, Dhaka, Bangladesh', 1, NULL, NULL, N'27', 1)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'5f277f6d-3ae8-4a7c-8680-59c6f1168820', N'82e07bcb-35a6-4619-a177-0ba08aaa66bc', CAST(N'2019-10-28T11:01:34.163' AS DateTime), CAST(23.7723136000 AS Decimal(18, 10)), CAST(90.3645191000 AS Decimal(18, 10)), N'Khilji Road, Dhaka, Bangladesh', 1, NULL, NULL, N'27', 1)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'107fa91a-43d4-410a-b236-6197606f3001', N'061297b5-699d-44e5-ac81-b518569fca29', CAST(N'2019-10-27T17:55:25.813' AS DateTime), CAST(23.4074361000 AS Decimal(18, 10)), CAST(88.3605674000 AS Decimal(18, 10)), N'Sarkarpara Lane, Nabadwip, India', NULL, 1, NULL, N'24', 5)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'37bb4467-ff7c-4888-89fe-6827e7eb8a80', N'061297b5-699d-44e5-ac81-b518569fca29', CAST(N'2019-10-27T17:54:05.483' AS DateTime), CAST(23.4074361000 AS Decimal(18, 10)), CAST(88.3605674000 AS Decimal(18, 10)), N'Sarkarpara Lane, Nabadwip, India', 1, NULL, NULL, N'24', 5)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'ec188e2a-eb85-4a0e-88dc-7b7930c82537', N'48bbf338-fe85-4da4-8aeb-f80eda4df816', CAST(N'2019-10-27T17:50:54.437' AS DateTime), CAST(23.4074361000 AS Decimal(18, 10)), CAST(88.3605674000 AS Decimal(18, 10)), N'Sarkarpara Lane, Nabadwip, India', NULL, NULL, NULL, N'24', 5)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'3593ea1b-8b88-43d2-af84-82059196b5c3', N'48bbf338-fe85-4da4-8aeb-f80eda4df816', CAST(N'2019-10-27T17:50:54.217' AS DateTime), CAST(23.4074361000 AS Decimal(18, 10)), CAST(88.3605674000 AS Decimal(18, 10)), N'Sarkarpara Lane, Nabadwip, India', NULL, NULL, NULL, N'24', 5)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'123cb108-ff76-4e6e-9c62-9b0eae6b4133', N'48bbf338-fe85-4da4-8aeb-f80eda4df816', CAST(N'2019-10-27T17:51:05.407' AS DateTime), CAST(23.4074361000 AS Decimal(18, 10)), CAST(88.3605674000 AS Decimal(18, 10)), N'Sarkarpara Lane, Nabadwip, India', NULL, NULL, NULL, N'24', 5)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'7d12b597-86e6-494e-8897-9be716dbf880', N'82e07bcb-35a6-4619-a177-0ba08aaa66bc', CAST(N'2019-10-28T11:01:45.787' AS DateTime), CAST(23.7723462000 AS Decimal(18, 10)), CAST(90.3644971000 AS Decimal(18, 10)), N'Khilji Road, Dhaka, Bangladesh', NULL, NULL, NULL, N'27', 1)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'4bacad62-315e-4827-af56-9e1b8f554ec5', N'f4bf2ddb-6448-42ec-bc6a-ae06d724446c', CAST(N'2019-10-27T12:58:00.797' AS DateTime), CAST(23.4117790000 AS Decimal(18, 10)), CAST(88.3605890000 AS Decimal(18, 10)), N'Buroshib Tala Road, Nabadwip, India', NULL, 1, NULL, N'24', 4)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'182be635-9def-42e7-a9f2-b9690fe0cec2', N'82e07bcb-35a6-4619-a177-0ba08aaa66bc', CAST(N'2019-10-28T11:02:09.507' AS DateTime), CAST(23.7726324000 AS Decimal(18, 10)), CAST(90.3643623000 AS Decimal(18, 10)), N'Road No. 5, Dhaka, Bangladesh', NULL, NULL, NULL, N'27', 1)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'c556f54f-d69e-4877-b0fa-c07b378215ed', N'82e07bcb-35a6-4619-a177-0ba08aaa66bc', CAST(N'2019-10-23T07:48:11.010' AS DateTime), CAST(23.7723458000 AS Decimal(18, 10)), CAST(90.3644872000 AS Decimal(18, 10)), N'Khilji Road, Dhaka, Bangladesh', NULL, NULL, NULL, N'27', 1)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'35dd59dc-4abc-4e93-bc1f-f23d879a8230', N'48bbf338-fe85-4da4-8aeb-f80eda4df816', CAST(N'2019-10-27T17:50:44.983' AS DateTime), CAST(23.4116967000 AS Decimal(18, 10)), CAST(88.3621761000 AS Decimal(18, 10)), N'Buroshib Tala Road, Nabadwip, India', 1, NULL, NULL, N'24', 5)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'7f19e9fe-7ed6-40a8-b03b-f36a1fb6b4da', N'48bbf338-fe85-4da4-8aeb-f80eda4df816', CAST(N'2019-10-27T17:51:38.890' AS DateTime), CAST(23.4074361000 AS Decimal(18, 10)), CAST(88.3605674000 AS Decimal(18, 10)), N'Sarkarpara Lane, Nabadwip, India', NULL, NULL, NULL, N'24', 5)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'5f711a7f-d5b2-44a9-b13c-f7d5fd735fd9', N'c9404973-e5e5-4eb9-82fa-e769698b579a', CAST(N'2019-10-26T02:34:33.013' AS DateTime), CAST(-6.3238595000 AS Decimal(18, 10)), CAST(107.0494842000 AS Decimal(18, 10)), N'Jalan Dharma Bhakti, Kecamatan Setu, Indonesia', 1, NULL, NULL, N'26', 1)
INSERT [dbo].[ResourceTracker_UserMovementLog] ([Id], [UserId], [LogDateTime], [Latitude], [Longitude], [LogLocation], [IsCheckInPoint], [IsCheckOutPoint], [DeviceName], [DeviceOSVersion], [CompanyId]) VALUES (N'1516d3bd-289b-4c4d-8b23-fd0fd3697b92', N'82e07bcb-35a6-4619-a177-0ba08aaa66bc', CAST(N'2019-10-28T11:01:40.570' AS DateTime), CAST(23.7723353000 AS Decimal(18, 10)), CAST(90.3644986000 AS Decimal(18, 10)), N'Khilji Road, Dhaka, Bangladesh', NULL, NULL, NULL, N'27', 1)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'82e07bcb-35a6-4619-a177-0ba08aaa66bc', N'Abu Hasan', N'tapantor24@gmail.com', N'01736659047', N'01736659047', N'2B2E8746DCD8035CD3282198180E32AB', 7, 1, CAST(N'2019-10-23T07:42:14.180' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'494fbf63-a1c9-4e2d-b205-36939b6ca36e', N'Ripon', N'tapantor24@gmail.com ', N'01736659048', N'01736659048', N'32A3BCDDD78AE75AE50D0D3D97E03E3E', 7, 1, CAST(N'2019-10-23T08:41:10.880' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'2ac7a9a2-4027-472d-b33a-402315c72614', N'Tapas', N'Ggsgs@6ys.vsv', N'1234', N'1234', N'E10ADC3949BA59ABBE56E057F20F883E', 6, 1, CAST(N'2019-10-27T14:13:12.530' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'f0e8c5d0-bbbb-46d4-bbdd-46f701410864', N'budi', N'budirstnt@gmail.com', N'085727951770', N'085727951770', N'E10ADC3949BA59ABBE56E057F20F883E', 6, 1, CAST(N'2019-10-27T03:37:32.230' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'3792b1d6-04a5-4ee8-a098-56273d00c40a', N'Amin Sharif', N'tapantor24@gmail.com', N'01726324631', N'01726324631', N'C08B7B42FAA0F15174AA29004EF8F5B0', 7, 1, CAST(N'2019-10-23T08:30:13.287' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'a799bc80-0d2b-437a-bc9e-62eb5530deda', N'Budi Ristanto', N'budirstnt@gmail.com', N'085727951773', N'085727951773', N'E10ADC3949BA59ABBE56E057F20F883E', 6, 1, CAST(N'2019-10-27T11:50:21.810' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'8388ec92-ff00-4868-828d-6fc368239f67', N'tfg', N'Way4digiadd@gmail.com', N'55865', N'55865', N'10A6FE26430C32FA430E566FA1FCA608', 7, 1, CAST(N'2019-10-27T12:36:18.090' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'1048519d-c50d-467c-af6e-75beee0cce48', N'ram', N'Gacgs@66.nh', N'354', N'354', N'605B75D156FAD48670653AACAE3B555D', 7, 1, CAST(N'2019-10-27T12:38:04.373' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'334b9eab-e5ee-4db7-8f1a-99728bd671a0', N'Tapas', N'tapas6650@GMAIL.COM', N'523855332', N'523855332', N'177BF5A93EC4F28E46300D70AC10238D', 6, 1, CAST(N'2019-10-27T12:07:00.623' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'f4bf2ddb-6448-42ec-bc6a-ae06d724446c', N'ram', N'Tgdh@773.nsj', N'6464', N'6464', N'4617843D9087C88E065B0632C5504501', 7, 1, CAST(N'2019-10-27T12:39:16.623' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'061297b5-699d-44e5-ac81-b518569fca29', N'tt', N'Rff@65.com', N'2223', N'2223', N'A3FB3E8E100904B94809C0711201BEA2', 7, 1, CAST(N'2019-10-27T17:44:54.497' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'266ca3a8-b35f-49e0-83ba-da91ef2d2730', N'Jafor Sadek', N'tapantor24@gmail.com', N'01670959051', N'01670959051', N'25D55AD283AA400AF464C76D713C07AD', 6, 1, CAST(N'2019-10-23T06:46:40.930' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'c9fb99c2-51e1-4a77-ae0f-de59b6c90c07', N'Test', N'willofd0202@gmail.com', N'0195091198', N'0195091198', N'E10ADC3949BA59ABBE56E057F20F883E', 6, 1, CAST(N'2019-10-28T06:37:53.473' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'c9404973-e5e5-4eb9-82fa-e769698b579a', N'Tajuddin', N'ceasar13690@gmail.com', N'01916387657', N'01916387657', N'126E7204A97FD1564D253F7A8B482BE5', 7, 1, CAST(N'2019-10-23T07:30:14.807' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'a86d1b3d-b9fd-41c0-be56-ebdc3b888eab', N'Andi Agus Salim', N'pelajarpro@gmail.com', N'081355147878', N'081355147878', N'E10ADC3949BA59ABBE56E057F20F883E', 6, 1, CAST(N'2019-10-26T16:20:34.590' AS DateTime), NULL, NULL)
INSERT [dbo].[UserCredentials] ([Id], [FullName], [Email], [ContactNo], [LoginID], [Password], [UserTypeId], [IsActive], [CreatedAt], [Theme], [OrganizationId]) VALUES (N'48bbf338-fe85-4da4-8aeb-f80eda4df816', N'tr', N'Gdgd@77.nd', N'96698', N'96698', N'0DB53F651548F599691B9D54791E4C6F', 7, 1, CAST(N'2019-10-27T17:46:00.030' AS DateTime), NULL, NULL)
ALTER TABLE [dbo].[ResourceTracker_EmployeeUser]  WITH CHECK ADD  CONSTRAINT [FK_ResourceTracker_EmployeeUser_ResourceTracker_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[ResourceTracker_Company] ([Id])
GO
ALTER TABLE [dbo].[ResourceTracker_EmployeeUser] CHECK CONSTRAINT [FK_ResourceTracker_EmployeeUser_ResourceTracker_Company]
GO
ALTER TABLE [dbo].[ResourceTracker_EmployeeUser]  WITH CHECK ADD  CONSTRAINT [FK_ResourceTracker_EmployeeUser_ResourceTracker_Department] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[ResourceTracker_Department] ([Id])
GO
ALTER TABLE [dbo].[ResourceTracker_EmployeeUser] CHECK CONSTRAINT [FK_ResourceTracker_EmployeeUser_ResourceTracker_Department]
GO
ALTER TABLE [dbo].[ResourceTracker_LeaveApplication]  WITH CHECK ADD  CONSTRAINT [FK_ResourceTracker_LeaveApplication_ResourceTracker_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[ResourceTracker_Company] ([Id])
GO
ALTER TABLE [dbo].[ResourceTracker_LeaveApplication] CHECK CONSTRAINT [FK_ResourceTracker_LeaveApplication_ResourceTracker_Company]
GO
ALTER TABLE [dbo].[ResourceTracker_Task]  WITH CHECK ADD  CONSTRAINT [FK_ResourceTracker_Task_ResourceTracker_TaskGroup] FOREIGN KEY([TaskGroupId])
REFERENCES [dbo].[ResourceTracker_TaskGroup] ([Id])
GO
ALTER TABLE [dbo].[ResourceTracker_Task] CHECK CONSTRAINT [FK_ResourceTracker_Task_ResourceTracker_TaskGroup]
GO
ALTER TABLE [dbo].[ResourceTracker_TaskAttachments]  WITH CHECK ADD  CONSTRAINT [FK_ResourceTracker_TaskAttachments_ResourceTracker_Task] FOREIGN KEY([TaskId])
REFERENCES [dbo].[ResourceTracker_Task] ([Id])
GO
ALTER TABLE [dbo].[ResourceTracker_TaskAttachments] CHECK CONSTRAINT [FK_ResourceTracker_TaskAttachments_ResourceTracker_Task]
GO
ALTER TABLE [dbo].[ResourceTracker_ToDoTaskShare]  WITH CHECK ADD  CONSTRAINT [FK_ResourceTracker_ToDoTaskShare_ResourceTracker_ToTask] FOREIGN KEY([TaskId])
REFERENCES [dbo].[ResourceTracker_ToDoTask] ([Id])
GO
ALTER TABLE [dbo].[ResourceTracker_ToDoTaskShare] CHECK CONSTRAINT [FK_ResourceTracker_ToDoTaskShare_ResourceTracker_ToTask]
GO
USE [master]
GO
ALTER DATABASE [trillion_hrappdb] SET  READ_WRITE 
GO
