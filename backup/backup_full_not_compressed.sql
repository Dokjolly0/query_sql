-- Abilita xp_cmdshell se non è già abilitato
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;

DECLARE @BackupFile NVARCHAR(255);
SET @BackupFile = 'D:\Backups\TestDB_Full_' + 
                  FORMAT(GETDATE(), 'yyyy-MM-dd_HH-mm-ss') + 
                  '.bak';

-- Esegui il backup completo del database senza compressione
BACKUP DATABASE TestDB 
TO DISK = @BackupFile 
WITH INIT, NAME = 'Backup completo'; -- Nessuna opzione di compressione

-- Controllo se il backup è andato a buon fine
IF @@ERROR = 0
BEGIN
    -- Elimina i backup più vecchi, mantenendo solo i 2 più recenti
    DECLARE @FilePath NVARCHAR(255) = 'D:\Backups\TestDB_Full_';
    DECLARE @Command NVARCHAR(255);
    DECLARE @File NVARCHAR(255);
    DECLARE @DeleteCommand NVARCHAR(255);
    DECLARE @Count INT = 0;

    -- Crea una tabella temporanea per memorizzare i nomi dei file
    CREATE TABLE #BackupFiles (FileName NVARCHAR(255));

    -- Recupera l'elenco dei file di backup esistenti
    INSERT INTO #BackupFiles (FileName)
    EXEC xp_cmdshell 'dir /b "D:\Backups\TestDB_Full_*.bak"';

    -- Debug: Stampa l'elenco dei file di backup trovati
    SELECT * FROM #BackupFiles WHERE FileName IS NOT NULL;

    -- Elimina i file più vecchi, mantenendo solo i 2 più recenti
    DECLARE file_cursor CURSOR FOR
    SELECT FileName FROM #BackupFiles WHERE FileName IS NOT NULL ORDER BY FileName DESC;

    OPEN file_cursor;
    FETCH NEXT FROM file_cursor INTO @File;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Count += 1;

        IF @Count > 2  -- Modificato da 3 a 2
        BEGIN
            -- Debug: Stampa il file che si sta per eliminare
            PRINT 'Eliminando file: ' + @File;

            SET @DeleteCommand = 'DEL /Q "D:\Backups\' + @File + '"'; -- Utilizza /Q per silenziare l'output
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

        FETCH NEXT FROM file_cursor INTO @File;
    END

    CLOSE file_cursor;
    DEALLOCATE file_cursor;

    -- Elimina la tabella temporanea
    DROP TABLE #BackupFiles;
END
GO
