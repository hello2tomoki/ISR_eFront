CREATE TABLE [SCD].[Position_Update_Date_Process_Log] (
    [VW_Position_Update_Date_Key] INT           NOT NULL,
    [EFFECTIVE_DATE]              DATETIME      NULL,
    [UpdateDate_EDM]              DATETIME      NULL,
    [CADIS_SYSTEM_UPDATED]        DATETIME      NULL,
    [Function_Name]               VARCHAR (100) NULL,
    [IS_Complete]                 BIT           DEFAULT ((0)) NULL,    
    [Inserted_Date]               DATETIME      DEFAULT (getdate()) NULL,
	[Last_Update_Date]            DATETIME      NULL,
	[InsertedBy]                  [sysname]     DEFAULT (suser_sname()) NULL,
    [Source]                      VARCHAR (100) NULL,
) ON [SCD];

