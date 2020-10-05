Function BackupProject(){
	Param(
		[Parameter(Mandatory=$true, Position=0)]
		[string] $projectPATH,
		[Parameter(Mandatory=$true, Position=1)]
		[string] $backupProjectFolder
	)
	
	$includeList = @("admin", "web", "www", "business")

	#Create project backup folder and copy old modules current project in backup folder
    if ((Test-Path $projectPATH) -and !(Test-Path "$projectPATH\$backupProjectFolder")) {
        try{
            ForEach ($include in $includeList){
                $include
                if(Test-Path "$projectPATH\$include" ){
                    Copy-Item -Path "$projectPATH\$include" -Destination "$projectPATH\$backupProjectFolder\$include" -Recurse -Force
                }
            }
		} catch [Exception] {
			WriteLog -error "Error when trying to copy project from $($_.fullname) to $backupFolder $($_.Exception.GetType().FullName), $($_.Exception.Message)" -ErrorAction Stop
	    }
        echo "Congrats! Backup for current project is completed."
        WriteLog -info "Backup for project created, PATH: $projectPATH\$backupProjectFolder"
	} else {
        if(Test-Path "$projectPATH\$backupProjectFolder") {
            #WriteLog -warn "Backup for project $(Split-Path $backupPATH -Leaf) is already exists"
			WriteLog -warn "Backup for project $backupProjectFolder is already exists"
        }
    }
}
