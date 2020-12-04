

CREATE   PROCEDURE [ETL].[Create_New_Temporal_Tables]
(@BatchLoggingId INT          , 
 @PrintOutput    VARCHAR(MAX) = NULL OUTPUT
)
AS

/*
**************************************************************************************************
Procedure Name	: etl.Create_New_Temporal_SCD_Tables		
Purpose			: The routine will create new SCD tables as new FNS are exposed within
					EDM. This routine is called from an SSIS package that attempts to automate and generate
					the required ETL packages
Created By:		: Pardeep Dosanjh
History			:
	
	08-Jan-2018		Created		Pardeep	
    02-Dec-2019    	Ported to SCD-->Risk Datastore Shiva Praneeth Palla


***************************************************************************************************
*/

    BEGIN
        DECLARE @LoggingDetailsDescription VARCHAR(250);
        DECLARE @TargetSchemaName VARCHAR(200)= 'eFront';
        DECLARE @Candidate_FN_List_Key INT;
        DECLARE @Destination_Table_Name VARCHAR(100);
        DECLARE @Create_Temporal_Table_SQL_Statement NVARCHAR(MAX);


        --- DECLARE @AlterTableSQLStatement NVARCHAR(500);
        DECLARE @DividingPrintLine VARCHAR(200);
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200);
        SET @DividingPrintLine = 'GO' + CHAR(13) + '--*******************************************************************************************************************';
        --Save logging information
        SET @LoggingDetailsDescription = 'Call: To Create SCD Temporal Tables ';
        EXEC etl.Save_Meta_Processing_Log_Record 
             @BatchLoggingId, 
             'SCDTable Temporal Creation', 
             @LoggingDetailsDescription, 
             NULL;
        DECLARE CreateTemporalTable_CUR CURSOR
        FOR
            WITH Get_List_Of_SCD_FNS
                 AS(SELECT Candidate_FN_List_Key, 
                           Destination_Table_Name, 
                           Create_Temporal_Table_SQL_Statement
                          
                    FROM [etl].[Candidate_FN_List]
                    WHERE [IS_Processed] = 0
					And [IS_Temporal_Table_Created] =0
					--AND  [IS_New] =1
					--AND Create_DB_Objects <>0 
               AND  Batch_Logging_Id = @BatchLoggingId
                 )
                 SELECT Candidate_FN_List_Key, 
                        Destination_Table_Name, 
                        Create_Temporal_Table_SQL_Statement
                       
                 FROM Get_List_Of_SCD_FNS SCD
                 --  Order by 
                 --                      WHERE NOT EXISTS
                 --(
                 --    SELECT 1
                 --    FROM sys.tables
                 --    WHERE schema_id = SCHEMA_ID(SCD.[Schema_Name])
                 --          AND name = Replace(SCD.Destination_Table_Name, SCD.[Schema_Name]+'.', '')
                 --)
                 ORDER BY Candidate_FN_List_Key;
        OPEN CreateTemporalTable_CUR;
        FETCH NEXT FROM CreateTemporalTable_CUR INTO @Candidate_FN_List_Key, @Destination_Table_Name, @Create_Temporal_Table_SQL_Statement;
        WHILE @@FETCH_STATUS = 0
            BEGIN
                BEGIN TRY
                    BEGIN TRANSACTION;

/* Add this to stop dropping Exising Tables */
                         IF
(
    SELECT object_id
    FROM sys.tables
    WHERE schema_id = SCHEMA_ID(@TargetSchemaName)
          AND name =  @Destination_Table_Name
		  And temporal_type=2
) IS  NULL

/* Add this to stop dropping Exising Tables */
                    --				--Create the Missing table		
                    --                             SELECT 1;
					Begin 
                    EXEC (@Create_Temporal_Table_SQL_Statement);
                    SELECT @PrintOutput = ISNULL(@PrintOutput, '') + CHAR(13) + @Create_Temporal_Table_SQL_Statement + CHAR(13);
                    SET @LoggingDetailsDescription = 'Successful: Creation Of SCD Staging  Tables: ' + 'Temporal_' + @TargetSchemaName + '.' + @Destination_Table_Name;
                    EXEC [etl].[Save_Meta_Processing_Log_Record] 
                         @BatchLoggingId, 
                         'SCD Table Creation', 
                         @LoggingDetailsDescription, 
                         NULL;
                    UPDATE [etl].[Candidate_FN_List]
                      SET 
                          [IS_Temporal_Table_Created] = 1
                    WHERE Candidate_FN_List_Key = @Candidate_FN_List_Key;
End


                    --Alter the new table to add Default Values

/* No Longer Required Part this logic is now part of create statement
                         EXEC (@AlterTableSQLStatement);
                         SELECT @PrintOutput = @PrintOutput + CHAR(13) + @AlterTableSQLStatement + CHAR(13);
                         SET @AlterTableSQLStatement = 'ALTER TABLE '+@TargetSchemaName+'.'+@FullTableName+CHAR(13)+'ADD  DEFAULT (getdate()) FOR [LineageTMST] ';
                         EXEC (@AlterTableSQLStatement);
                         SELECT @PrintOutput = @PrintOutput + CHAR(13) + @AlterTableSQLStatement + CHAR(13);
                         SET @AlterTableSQLStatement = 'ALTER TABLE '+@TargetSchemaName+'.'+@FullTableName+CHAR(13)+'ADD  DEFAULT ((0)) FOR [LineageID]';
                         EXEC (@AlterTableSQLStatement);
                         SELECT @PrintOutput = @PrintOutput + CHAR(13) + @AlterTableSQLStatement + CHAR(13);
                         SET @AlterTableSQLStatement = 'ALTER TABLE '+@TargetSchemaName+'.'+@FullTableName+CHAR(13)+'ADD  DEFAULT (getdate()) FOR [InsertTMST]';
                         EXEC (@AlterTableSQLStatement);
                         SELECT @PrintOutput = @PrintOutput + CHAR(13) + @AlterTableSQLStatement + CHAR(13);
                         SET @AlterTableSQLStatement = 'ALTER TABLE '+@TargetSchemaName+'.'+@FullTableName+CHAR(13)+'ADD  DEFAULT (suser_sname()) FOR [InsertedBy]';
                         PRINT(@AlterTableSQLStatement);
                         SELECT @PrintOutput = @PrintOutput + CHAR(13) + @AlterTableSQLStatement + CHAR(13);
                         SET @LoggingDetailsDescription = 'Successful: Altered SCD Table: '+@TargetSchemaName+'.'+@FullTableName+', added additional fields and constraints';


                         EXEC [etl].[Save_Meta_Processing_Log_Record]
                              @BatchLoggingId,
                              'SCD Table Alter',
                              @LoggingDetailsDescription,
                              NULL;
 No Longer Required Part this logic is now part of create statement */

                    COMMIT TRANSACTION;
                    SELECT @PrintOutput = @PrintOutput + CHAR(13) + @DividingPrintLine + CHAR(13);
                    FETCH NEXT FROM CreateTemporalTable_CUR INTO @Candidate_FN_List_Key, @Destination_Table_Name, @Create_Temporal_Table_SQL_Statement;
                END TRY
                BEGIN CATCH		
                    -- Assign variables to error-handling functions that 
                    -- capture information for RAISERROR.
                    SELECT @ErrorNumber = ERROR_NUMBER(), 
                           @ErrorSeverity = ERROR_SEVERITY(), 
                           @ErrorState = ERROR_STATE(), 
                           @ErrorLine = ERROR_LINE(), 
                           @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-'), 
                           @ErrorMessage = 'ROLLBACK TRANSACTION: ' + ERROR_MESSAGE();
                    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);

                    -- Roll back any active or uncommittable transactions before
                    -- inserting information in the ErrorLog.
                    IF @@TRANCOUNT <> 0
                        BEGIN
                            PRINT N'The transaction is NOT committable. ' + 'Rollingback transaction.';
                            ROLLBACK TRANSACTION;
                    END;
                    SET @LoggingDetailsDescription = 'Error: etl.Create_New_Temporal_SCD_Tables ' + @TargetSchemaName + ',' + CONVERT(VARCHAR(10), @BatchLoggingId) + ' Table: ' + @TargetSchemaName + '.' + @Destination_Table_Name;
                    EXEC [etl].[Save_Meta_Processing_Log_Record] 
                         @BatchLoggingId, 
                         'etl.Create_New_Temporal_SCD_Tables', 
                         @LoggingDetailsDescription, 
                         @ErrorMessage;
                    GOTO Exit_Cur;
                END CATCH;
            END; -- WHILE
        Exit_Cur:
        CLOSE CreateTemporalTable_CUR;
        DEALLOCATE CreateTemporalTable_CUR;

-----


    END;