-- Abilita xp_cmdshell se non è già abilitato
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;

DECLARE @LogBackupFile NVARCHAR(255);
SET @LogBackupFile = 'D:\Backups\TestDB_Log_' + 
                     FORMAT(GETDATE(), 'yyyy-MM-dd_HH-mm-ss') + 
                     '.trn';

-- Esegui il backup del log di transazione senza compressione
BACKUP LOG TestDB 
TO DISK = @LogBackupFile 
WITH INIT, NAME = 'Backup log'; -- Nessuna opzione di compressione

-- Controllo se il backup è andato a buon fine
IF @@ERROR = 0
BEGIN
    -- Elimina i backup più vecchi, mantenendo solo i 2 più recenti
    DECLARE @LogFilePath NVARCHAR(255) = 'D:\Backups\TestDB_Log_';
    DECLARE @Command NVARCHAR(255);
    DECLARE @LogFile NVARCHAR(255);
    DECLARE @DeleteCommand NVARCHAR(255);
    DECLARE @Count INT = 0;

    -- Crea una tabella temporanea per memorizzare i nomi dei file
    CREATE TABLE #LogBackupFiles (FileName NVARCHAR(255));

    -- Recupera l'elenco dei file di backup esistenti
    INSERT INTO #LogBackupFiles (FileName)
    EXEC xp_cmdshell 'dir /b "D:\Backups\TestDB_Log_*.trn"';

    -- Debug: Stampa l'elenco dei file di backup trovati
    SELECT * FROM #LogBackupFiles WHERE FileName IS NOT NULL;

    -- Elimina i file più vecchi, mantenendo solo i 2 più recenti
    DECLARE file_cursor CURSOR FOR
    SELECT FileName FROM #LogBackupFiles WHERE FileName IS NOT NULL ORDER BY FileName DESC;

    OPEN file_cursor;
    FETCH NEXT FROM file_cursor INTO @LogFile;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Count += 1;

        IF @Count > 2  -- Modificato da 3 a 2
        BEGIN
            -- Debug: Stampa il file che si sta per eliminare
            PRINT 'Eliminando file: ' + @LogFile;

            SET @DeleteCommand = 'DEL /Q "D:\Backups\' + @LogFile + '"'; -- Utilizza /Q per silenziare l'output
            DECLARE @DeleteOutput NVARCHAR(255);

            -- Esegui il comando di eliminazione e cattura l'output
            EXEC @DeleteOutput = xp_cmdshell @DeleteCommand;

            -- Controlla se ci sono errori durante l'eliminazione
            IF @DeleteOutput IS NOT NULL
            BEGIN
                PRINT 'Output del comando di eliminazione:';
                PRINT @DeleteOutput;
            END
        END

        FETCH NEXT FROM file_cursor INTO @LogFile;
    END

    CLOSE file_cursor;
    DEALLOCATE file_cursor;

    -- Elimina la tabella temporanea
    DROP TABLE #LogBackupFiles;
END
GO
