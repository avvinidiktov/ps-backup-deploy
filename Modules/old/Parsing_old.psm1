Function BackupDB() {
    param(
    [Parameter(Mandatory=$true, Position=0)]
	[string] $configFilePath,
    [Parameter(Mandatory=$true, Position=1)]
    [string] $timestamp
    )
    if(Test-Path "$configFilePath\Web.config") {
        
        try {
            [xml]$connstr = Get-Content "$configFilePath\Web.config"
            $data = $connstr.configuration.connectionStrings.add | Select-Object -exp connectionstring -First 1
            $data -match 'Data Source=(.+);Initial Catalog=(.+);User ID=(.+);Password=.+'
            $dbServer = $Matches[1]
            $dbName = $Matches[2]
        } catch {
            Write-Error "DB backup ERROR!" -ErrorAction Stop
        }
    
    
        try {
            "TRACE-START Backing up database: $dbName"

            # Backup-SqlDatabase -BackupAction Database -CompressionOption On -ServerInstance $dbServer -BackupContainer "D:\Backups\$dbName"_"$backupDate.bak"  -Database $dbName -Verbose
            Backup-SqlDatabase -BackupAction Database -CompressionOption On -ServerInstance $dbServer -BackupFile $dbName"_"$backupDate  -Database $dbName -Verbose
            
            "TRACE-END"
        } catch {
            throw ("Backup of database: {0} failed. Error: {1}" -f "$dbName", $_.exception.message)
        }
    }
}