USE master;
GO

-- Sostituisci con il nome del tuo database
DECLARE @DatabaseName NVARCHAR(255) = 'TestDB';
DECLARE @DiffBackupFile NVARCHAR(255) = 'D:\Backups\TestDB_Diff_2024-10-11_17-00-22.bak';

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

-- Ripristina il backup differenziale
EXEC('RESTORE DATABASE [' + @DatabaseName + '] FROM DISK = ''' + @DiffBackupFile + ''' WITH REPLACE, RECOVERY;');

PRINT 'Ripristino differenziale eseguito con successo!';
GO
