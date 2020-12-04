CREATE TABLE [SCD].[Position_Counts_Log] (
    [Position_Counts_Log_Key]   INT          IDENTITY (1, 1) NOT NULL,
    [TransactionID]             INT          NULL,
    [Cnt]                       INT          NULL,
    [Effective_Date]            DATETIME     NULL,
    [SOURCE]                    VARCHAR (50) NULL,
    [ACCOUNTING_FRAMEWORK]      VARCHAR (10) NULL,
    [PORTFOLIO_CALCULATION]     VARCHAR (25) NULL,
    [EDM_Last_Processed_Time]   DATETIME     NULL,
    [LineageID]                 INT          NULL,
    [Last_Update_Date]          DATETIME     DEFAULT (getdate()) NULL,
    [ISR_Processing_Start_Time] DATETIME     NULL,
    [ISR_Processing_End_Time]   DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([Position_Counts_Log_Key] ASC)
);

