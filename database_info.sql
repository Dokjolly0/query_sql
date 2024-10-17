SELECT 
    db.name AS 'Database Name',
    db.state_desc AS 'Database State',
    db.recovery_model_desc AS 'Recovery Model',
    db.compatibility_level AS 'Compatibility Level',
    db.create_date AS 'Creation Date',
    db.owner_sid AS 'Owner SID',
    SERVERPROPERTY('ServerName') AS 'Server Name',
    SERVERPROPERTY('InstanceName') AS 'Instance Name',
    SERVERPROPERTY('MachineName') AS 'Machine Name',
    SERVERPROPERTY('ProductVersion') AS 'Product Version',
    SERVERPROPERTY('Edition') AS 'Edition',
    SERVERPROPERTY('ProductLevel') AS 'Product Level'
FROM 
    sys.databases db
WHERE 
    db.name = 'TestDB';
