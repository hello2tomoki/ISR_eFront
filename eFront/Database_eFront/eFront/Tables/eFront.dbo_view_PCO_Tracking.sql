CREATE TABLE [eFront].[dbo_view_PCO_Tracking](
	[dbo_view_PCO_Tracking_Key] [int] IDENTITY(1,1) NOT NULL,
	[Program] [nvarchar](510) NULL,
	[Investment Type] [nvarchar](510) NULL,
	[Fund] [nvarchar](510) NULL,
	[Company] [nvarchar](510) NULL,
	[Industry] [nvarchar](510) NULL,
	[Industry GICS] [nvarchar](510) NULL,
	[Geography] [nvarchar](510) NULL,
	[Original country] [nvarchar](510) NULL,
	[Fund Currency] [nvarchar](510) NULL,
	[Company Currency] [nvarchar](510) NULL,
	[Current Valuation] [float] NULL,
	[BCI CAD Ownership] [float] NULL,
	[BCI Ownership %] [float] NULL,
	[ID] [nvarchar](510) NULL,
	[BCI Vehicle Size] [float] NULL,
	[Aggregate Size] [float] NULL,
	[effectiveDate] [date] NULL,
	[TransactionID] [int] NULL,
	[RowHash] [varbinary](max) NULL,
	[LineageTMST] [datetime] NULL,
	[LineageID] [int] NULL,
	[InsertTMST] [datetime] NULL,
	[InsertedBy] [sysname] NOT NULL,
	[ValidFrom_utc] [datetime2](3) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo_utc] [datetime2](3) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[dbo_view_PCO_Tracking_Key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [eFront],
	PERIOD FOR SYSTEM_TIME ([ValidFrom_utc], [ValidTo_utc])
) TEXTIMAGE_ON [eFront]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [History_eFront].[dbo_view_PCO_Tracking] )
)
GO

ALTER TABLE [eFront].[dbo_view_PCO_Tracking] ADD  DEFAULT (getdate()) FOR [LineageTMST]
GO

ALTER TABLE [eFront].[dbo_view_PCO_Tracking] ADD  DEFAULT (getdate()) FOR [InsertTMST]
GO

ALTER TABLE [eFront].[dbo_view_PCO_Tracking] ADD  DEFAULT (getdate()) FOR [ValidFrom_utc]
GO

ALTER TABLE [eFront].[dbo_view_PCO_Tracking] ADD  DEFAULT ('9999-12-31 23:59:59') FOR [ValidTo_utc]
GO
