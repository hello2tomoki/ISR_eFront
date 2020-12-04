


CREATE PROCEDURE [ETL].[Create_New_Stg_Tables]
(
@BatchLoggingId INT, 
@TargetSchemaName VARCHAR(200),
 @PrintOutput    VARCHAR(MAX) = NULL OUTPUT
)
AS

/*

exec [ETL].[Create_New_Stg_Tables]  1, 'stg_eFront', null

**************************************************************************************************
Procedure Name	: etl.Create_New_Stg_Tables		
Purpose			: The routine will create new  tables as new FNS are exposed within
					EDM. This routine is called from an SSIS package that attempts to automate and generate
					the required ETL packages
Created By:		: Pardeep Dosanjh
History			:
	
	08-Jan-2018		Created		Pardeep	
    02-Dec-2019    	Ported to -->IS Datastore Shiva Praneeth Palla


***************************************************************************************************
*/

    BEGIN
        DECLARE @LoggingDetailsDescription VARCHAR(250);
        DECLARE @Candidate_FN_List_Key INT;
        DECLARE @Destination_Table_Name VARCHAR(100);
        DECLARE @Create_Stg_Table_SQL_Statement NVARCHAR(MAX);
        DECLARE @Create_Temporal_Table_SQL_Statement NVARCHAR(MAX);

        --- DECLARE @AlterTableSQLStatement NVARCHAR(500);
        DECLARE @DividingPrintLine VARCHAR(200);
        DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200);
        SET @DividingPrintLine = 'GO' + CHAR(13) + '--*******************************************************************************************************************';
        --Save logging information
        SET @LoggingDetailsDescription = 'Call: To Create  Tables ';
        EXEC etl.Save_Meta_Processing_Log_Record 
             @BatchLoggingId, 
             'Table Creation', 
             @LoggingDetailsDescription, 
             NULL;
        DECLARE CreateStgTable_CUR CURSOR
        FOR
            WITH Get_List_Of_FNS
                 AS(SELECT Candidate_FN_List_Key, 
                           Destination_Table_Name, 
                           Create_Stg_Table_SQL_Statement
                    FROM [etl].[Candidate_FN_List]
                    WHERE IS_Processed = 0
                          --AND Create_DB_Objects <> 0
                            AND IS_New = 1

                 --BatchLoggingId = @BatchLoggingId
                 )
                 SELECT Candidate_FN_List_Key, 
                        Destination_Table_Name, 
                        Create_Stg_Table_SQL_Statement
                 FROM Get_List_Of_FNS 

                 ORDER BY Candidate_FN_List_Key;
        OPEN CreateStgTable_CUR;
        FETCH NEXT FROM CreateStgTable_CUR INTO @Candidate_FN_List_Key, @Destination_Table_Name, @Create_Stg_Table_SQL_Statement;
        WHILE @@FETCH_STATUS = 0
            BEGIN
                BEGIN TRY


					--print @Create_Stg_Table_SQL_Statement
					--return

					BEGIN TRANSACTION;
					exec (@Create_Stg_Table_SQL_Statement);
                    SELECT @PrintOutput = ISNULL(@PrintOutput, '') + CHAR(13) + @Create_Stg_Table_SQL_Statement + CHAR(13);
                    SET @LoggingDetailsDescription = 'Successful: Creation Of eFront Staging  Tables: ' + @TargetSchemaName + '.' + @Destination_Table_Name;
                    EXEC [etl].[Save_Meta_Processing_Log_Record] 
                         @BatchLoggingId, 
                         'eFront Table Creation', 
                         @LoggingDetailsDescription, 
                         NULL;
                    UPDATE [etl].[Candidate_FN_List]
                      SET 
                          [IS_Stg_Table_Created] = 1
                    WHERE Candidate_FN_List_Key = @Candidate_FN_List_Key;


                    COMMIT TRANSACTION;
                    SELECT @PrintOutput = @PrintOutput + CHAR(13) + @DividingPrintLine + CHAR(13);
                    FETCH NEXT FROM CreateStgTable_CUR INTO @Candidate_FN_List_Key, @Destination_Table_Name, @Create_Stg_Table_SQL_Statement;
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
                    SET @LoggingDetailsDescription = 'Error: etl.Create_New_Stg_Tables ' + @TargetSchemaName + ',' + CONVERT(VARCHAR(10), @BatchLoggingId) + ' Table: ' + @TargetSchemaName + '.' + @Destination_Table_Name;
                    EXEC [etl].[Save_Meta_Processing_Log_Record] 
                         @BatchLoggingId, 
                         'etl.Create_New_Stg_Tables', 
                         @LoggingDetailsDescription, 
                         @ErrorMessage;
                    GOTO Exit_Cur;
                END CATCH;
            END; -- WHILE
        Exit_Cur:
        CLOSE CreateStgTable_CUR;
        DEALLOCATE CreateStgTable_CUR;
    END;