function UpdateBusiness() {
	param(
        [Parameter(Mandatory=$true)]
        [string] $projectPATH,
		[Parameter(Mandatory=$true)]
        [string] $deployFolder,
        [Parameter(Mandatory=$true)]
        [string] $version
	)

    if((Test-Path "$projectPATH\business")){
        WriteLog -info "Module Business exists ---> Continue"
        try{
            Get-ChildItem -Path "$projectPATH\$deployFolder\$version\Business" -Recurse |
            ForEach-Object {
                if(!([System.IO.File]::Exists($_.FullName.Replace("\$deployFolder\$version", ""))) -or ([System.IO.Directory]::Exists($_.FullName.Replace("\$deployFolder\$version", ""))) ) {
                    Copy-Item -Path $_.FullName -Destination $_.FullName.Replace("$deployFolder\$version", "") -Force
                } else {
                    WriteLog -warn "Ignore: $_ -> Already exists in destination"
                }
            }
            WriteLog -info "Success! Business module updated ---> Start updating"
        } catch [Exception] {
            WriteLog -error "Error renewing module Business. Stack trace: $($_.Exception.GetType().FullName), $($_.Exception.Message)" -ErrorAction Stop
        }
    }

}