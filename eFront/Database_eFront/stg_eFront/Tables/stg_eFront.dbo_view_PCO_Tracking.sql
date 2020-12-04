CREATE TABLE [stg_eFront].[dbo_view_PCO_Tracking] (
    [Program]           NVARCHAR (510) NULL,
    [Investment Type]   NVARCHAR (510) NULL,
    [Fund]              NVARCHAR (510) NULL,
    [Company]           NVARCHAR (510) NULL,
    [Industry]          NVARCHAR (510) NULL,
    [Industry GICS]     NVARCHAR (510) NULL,
    [Geography]         NVARCHAR (510) NULL,
    [Original country]  NVARCHAR (510) NULL,
    [Fund Currency]     NVARCHAR (510) NULL,
    [Company Currency]  NVARCHAR (510) NULL,
    [Current Valuation] FLOAT (53)     NULL,
    [BCI CAD Ownership] FLOAT (53)     NULL,
    [BCI Ownership %]   FLOAT (53)     NULL,
    [ID]                NVARCHAR (510) NULL,
    [BCI Vehicle Size]  FLOAT (53)     NULL,
    [Aggregate Size]    FLOAT (53)     NULL,
    [effectiveDate]     DATE           NULL,

    [TransactionID]     INT            NULL,
    [LineageTMST]       DATETIME       NULL,
    [LineageID]         INT            NULL,
    [InsertTMST]        DATETIME       DEFAULT (getdate()) NULL,
    [InsertedBy]        [sysname]      DEFAULT (suser_sname()) NOT NULL
) ON [stg_eFront];

