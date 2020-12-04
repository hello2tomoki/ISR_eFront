CREATE TABLE [SCD].[Position_Update_Date] (
    [VW_Position_Update_Date_Key] INT          IDENTITY (1, 1) NOT NULL,
    [SOURCE]                      VARCHAR (50) NULL,
    [ACCOUNTING_FRAMEWORK]        VARCHAR (25) NULL,
	[PORTFOLIO_CALCULATION]       VARCHAR (25) NULL,
    [EFFECTIVE_DATE]              DATETIME     NULL,
    [UpdateDate]                  DATETIME     NULL,
    [CADIS_SYSTEM_UPDATED]        DATETIME     NULL,
    [TransactionID]               INT          NULL,
    [LineageTMST]                 DATETIME     NULL,
    [LineageID]                   INT          NULL,
    [InsertTMST]                  DATETIME     DEFAULT (getdate()) NULL,
    [InsertedBy]                  [sysname]    DEFAULT (suser_sname()) NULL,
    CONSTRAINT [PK_Position_Update_Date] PRIMARY KEY CLUSTERED ([VW_Position_Update_Date_Key] ASC) ON [SCD]
) ON [SCD];

