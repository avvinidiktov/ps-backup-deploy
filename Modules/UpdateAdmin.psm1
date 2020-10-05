function UpdateAdmin() {
	param(
        [Parameter(Mandatory=$true)]
        [string] $projectPATH,
		[Parameter(Mandatory=$true)]
        [string] $deployFolder,
        [Parameter(Mandatory=$true)]
        [string] $version
	)

    if((Test-Path "$projectPATH\admin")){
        WriteLog -info "Module Admin exists ---> Continue"
        try{
            Get-ChildItem -Path "$projectPATH\$deployFolder\$version\Admin" -Recurse |
            ForEach-Object {
                if(!([System.IO.File]::Exists($_.FullName.Replace("\$deployFolder\$version", ""))) -or ([System.IO.Directory]::Exists($_.FullName.Replace("\$deployFolder\$version", ""))) ) {
                    Copy-Item -Path $_.FullName -Destination $_.FullName.Replace("$deployFolder\$version", "") -Force
                } else {
                    WriteLog -warn "Ignore: $_ -> Already exists in destination"
                }
            }

            WriteLog -info "Success! Admin module updated ---> Continue"
        } catch [Exception] {
            WriteLog -error "Error renewing module Admin. Stack trace: $$($_.Exception.GetType().FullName), $($_.Exception.Message)" -ErrorAction Stop
        }
    }

}