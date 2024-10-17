USE master;

-- 1. Ripristina il backup completo
RESTORE DATABASE TestDB_Ripristinato 
FROM DISK = 'D:\Backups\TestDB_Full.bak' 
WITH MOVE 'TestDB' TO 'D:\Data\TestDB_Ripristinato.mdf', 
     MOVE 'TestDB_log' TO 'D:\Data\TestDB_Ripristinato_log.ldf', 
     REPLACE, NORECOVERY;
go

-- 2. Applica il backup differenziale
RESTORE DATABASE TestDB_Ripristinato 
FROM DISK = 'D:\Backups\TestDB_Diff.bak' 
WITH NORECOVERY; 
GO

-- 3. Completa il ripristino
RESTORE DATABASE TestDB_Ripristinato 
WITH RECOVERY;  
GO
