

CREATE PROCEDURE [eFront].[MergeSourceToDestination]

AS
BEGIN



MERGE [eFront].[dbo_view_PCO_Tracking] AS TARGET
USING ( select [Program]
      ,[Investment Type]
      ,[Fund]
      ,[Company]
      ,[Industry]
      ,[Industry GICS]
      ,[Geography]
      ,[Original country]
      ,[Fund Currency]
      ,[Company Currency]
      ,[Current Valuation]
      ,[BCI CAD Ownership]
      ,[BCI Ownership %]
      ,[ID]
      ,[BCI Vehicle Size]
      ,[Aggregate Size]
      ,[effectiveDate]
	  ,Hashbytes('SHA1', 			
							coalesce(cast([Program] as varchar(500)),'')
  					+ '|' + coalesce(cast([Investment Type] as varchar(500)),'')
					+ '|' + coalesce(cast([Fund] as varchar(500)),'')
					+ '|' + coalesce(cast([Company] as varchar(500)),'') 
					+ '|' + coalesce(cast([Industry] as varchar(500)),'') 
					+ '|' + coalesce(cast([Industry GICS] as varchar(500)),'') 
					+ '|' + coalesce(cast([Geography] as varchar(500)),'') 
					+ '|' + coalesce(cast([Original country] as varchar(500)),'') 
					+ '|' + coalesce(cast([Fund Currency] as varchar(500)),'') 
					+ '|' + coalesce(cast([Company Currency] as varchar(500)),'') 
					+ '|' + coalesce(cast([Current Valuation] as varchar(500)),'') 
					+ '|' + coalesce(cast([BCI CAD Ownership] as varchar(500)),'') 
					+ '|' + coalesce(cast([BCI Ownership %] as varchar(500)),'') 
					--+ '|' + coalesce(cast([ID] as varchar(500)),'') 
					+ '|' + coalesce(cast([BCI Vehicle Size] as varchar(500)),'') 
					+ '|' + coalesce(cast([Aggregate Size] as varchar(500)),'') 
					--+ '|' + coalesce(cast([effectiveDate] as varchar(500)),'') 
					+ '|' + coalesce(cast([TransactionID] as varchar(500)),'') 
					) AS RowHash
		,[TransactionID]
		,InsertedBy
from [stg_eFront].[dbo_view_PCO_Tracking]
 ) AS SOURCE 

ON (TARGET.effectivedate = SOURCE.effectivedate and Target.ID=Source.ID) 
--When records are matched, update the records if there is any change
WHEN MATCHED AND TARGET.RowHash <> SOURCE.RowHash  
THEN UPDATE SET 
	   TARGET.[Program]				= SOURCE.[Program]
      ,TARGET.[Investment Type]		= SOURCE.[Investment Type]
      ,TARGET.[Fund]				= SOURCE.[Fund]
      ,TARGET.[Company]				= SOURCE.[Company]
      ,TARGET.[Industry]			= SOURCE.[Industry]
      ,TARGET.[Industry GICS]		= SOURCE.[Industry GICS]
      ,TARGET.[Geography]			= SOURCE.[Geography]
      ,TARGET.[Original country]	= SOURCE.[Original country]
      ,TARGET.[Fund Currency]		= SOURCE.[Fund Currency]
      ,TARGET.[Company Currency]	= SOURCE.[Company Currency]
      ,TARGET.[Current Valuation]	= SOURCE.[Current Valuation]
      ,TARGET.[BCI CAD Ownership]	= SOURCE.[BCI CAD Ownership]
      ,TARGET.[BCI Ownership %]		= SOURCE.[BCI Ownership %]
      ,TARGET.[BCI Vehicle Size]	= SOURCE.[BCI Vehicle Size]
      ,TARGET.[Aggregate Size]		= SOURCE.[Aggregate Size]
	  ,TARGET.[RowHash]				= SOURCE.[RowHash]
--When no records are matched, insert the incoming records from source table to target table
WHEN NOT MATCHED BY TARGET 
THEN INSERT (
	   [Program]
      ,[Investment Type]
      ,[Fund]
      ,[Company]
      ,[Industry]
      ,[Industry GICS]
      ,[Geography]
      ,[Original country]
      ,[Fund Currency]
      ,[Company Currency]
      ,[Current Valuation]
      ,[BCI CAD Ownership]
      ,[BCI Ownership %]
      ,[ID]
      ,[BCI Vehicle Size]
      ,[Aggregate Size]
      ,[effectiveDate]
      ,[RowHash]
      ,[TransactionID]
	  ,[InsertedBy]
) VALUES (
	   SOURCE.[Program]
      ,SOURCE.[Investment Type]
      ,SOURCE.[Fund]
      ,SOURCE.[Company]
      ,SOURCE.[Industry]
      ,SOURCE.[Industry GICS]
      ,SOURCE.[Geography]
      ,SOURCE.[Original country]
      ,SOURCE.[Fund Currency]
      ,SOURCE.[Company Currency]
      ,SOURCE.[Current Valuation]
      ,SOURCE.[BCI CAD Ownership]
      ,SOURCE.[BCI Ownership %]
      ,SOURCE.[ID]
      ,SOURCE.[BCI Vehicle Size]
      ,SOURCE.[Aggregate Size]
      ,SOURCE.[effectiveDate]
      ,SOURCE.[RowHash]
      ,SOURCE.[TransactionID]
	  ,SOURCE.[InsertedBy]
	);
--When there is a row that exists in target and same record does not exist in source then delete this record target
--WHEN NOT MATCHED BY SOURCE 
--THEN DELETE; 



END