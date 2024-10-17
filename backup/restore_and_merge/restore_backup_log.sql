USE master;
GO

-- Sostituisci con il nome del tuo database
DECLARE @DatabaseName NVARCHAR(255) = 'TestDB';
DECLARE @LogBackupFile NVARCHAR(255) = 'D:\Backups\TestDB_Log_2024-10-11_17-00-09.trn';

-- Controlla se il database esiste e, in caso contrario, crealo
IF EXISTS (SELECT * FROM sys.databases WHERE name = @DatabaseName)
BEGIN
    PRINT 'Il database esiste già. Procedo con il ripristino...';
    
    -- Metti il database in modalità di emergenza per il ripristino
    EXEC('ALTER DATABASE [' + @DatabaseName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;');
END
ELSE
BEGIN
    PRINT 'Il database non esiste. Lo creerò...';
    
    -- Crea il database se non esiste
    EXEC('CREATE DATABASE [' + @DatabaseName + '];');
END

-- Ripristina il backup del log di transazione
EXEC('RESTORE LOG [' + @DatabaseName + '] FROM DISK = ''' + @LogBackupFile + ''' WITH RECOVERY;');

PRINT 'Ripristino del log di transazione eseguito con successo!';
GO
