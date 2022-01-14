USE [openeapi]
GO

/****** Object:  Table [dbo].[kontrollansvarig]    Script Date: 2022-01-14 15:03:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[kontrollansvarig](
	[id] [int] NOT NULL,
	[updated] [datetime] NOT NULL,
	[enabled] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[company] [nvarchar](150) NULL,
	[city] [nvarchar](100) NULL,
	[certtype] [nvarchar](150) NULL,
	[certby] [nvarchar](100) NULL,
	[certtodate] [date] NULL,
	[accessnumber] [nvarchar](75) NULL,
	[accesslevel] [nvarchar](10) NULL,
	[tel] [nvarchar](150) NULL,
	[adr] [nvarchar](250) NULL,
	[mail] [nvarchar](250) NULL,
	[county] [nvarchar](75) NOT NULL,
	[countycode] [nvarchar](10) NOT NULL
) ON [PRIMARY]
GO


