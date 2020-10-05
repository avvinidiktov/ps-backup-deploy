Function ExpandArchive() {
    Param(
        [Parameter(Mandatory=$true)]
        [string] $projectPATH,
        [Parameter(Mandatory=$true)]
        [string] $archivesPATH,
		[Parameter(Mandatory=$true)]
        [string] $name,
		[Parameter(Mandatory=$true)]
		[string] $deployFolder
    )
		
    if(Test-Path "$archivesPATH") {
        try{
            WriteLog -info "Archive exists ---> Expanding"
            Expand-Archive -LiteralPath "$archivesPATH\$name.zip" -DestinationPath "$projectPATH\$deployFolder" -Force
        } catch [Exception] {
            WriteLog -error "Error! Unable to expand archive. Stack trace: $($_.Exception.GetType().FullName, $_.Exception.Message)" -ErrorAction Stop
        }
    }
}