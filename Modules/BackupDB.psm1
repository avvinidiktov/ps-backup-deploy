Function BackupDB() {
    param(
    [Parameter(Mandatory=$true, Position=0)]
	[string] $configFilePath,
    [Parameter(Mandatory=$true, Position=1)]
    [string] $backupDbFolder
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
        $backupDate = Get-Date -format yyyy-MM-dd
		$fullBackupName = "$dbName"+"_"+"$backupDate"
    
        try {
            WriteLog -info "TRACE-START Backing up database: $dbName"

            # Backup-SqlDatabase -BackupAction Database -CompressionOption On -ServerInstance $dbServer -BackupContainer "D:\Backups\$dbName"_"$backupDate.bak"  -Database $dbName -Verbose
            WriteLog -info "$(Backup-SqlDatabase -BackupAction Database -ServerInstance $dbServer -BackupFile "\\$dbServer\$backupDbFolder\$fullBackupName" -Database $dbName -Verbose)"
             
            WriteLog -info "TRACE-END"
        } catch {
            WriteLog -error ("Backup of database: {0} failed. Error: {1}" -f "$dbName", $_.exception.message) -ErrorAction Stop
        }
    }
}