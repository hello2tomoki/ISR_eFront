CREATE  PROCEDURE eFront.sp_refreshViews_Schema @Schema_Name VARCHAR(200)
AS
    BEGIN
        DECLARE c CURSOR
        FOR SELECT TABLE_SCHEMA + '.' + TABLE_NAME
            FROM INFORMATION_SCHEMA.VIEWS
            WHERE TABLE_SCHEMA = 'rpt_eFront';
        OPEN c;
        DECLARE @ViewName VARCHAR(500);
        FETCH NEXT FROM c INTO @ViewName;
        WHILE @@fetch_status = 0
            BEGIN
                BEGIN TRY
                    PRINT 'sp_refreshView ' + @viewName + ' Started';
                    EXEC sp_refreshView 
                         @viewName;
                    PRINT 'sp_refreshView ' + @viewName + ' Completed';
                END TRY
                BEGIN CATCH
                    PRINT @viewName;
                END CATCH;
                FETCH NEXT FROM c INTO @viewName;
            END;
        CLOSE c;
        DEALLOCATE c;
    END ;