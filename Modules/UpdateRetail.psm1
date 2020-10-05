function UpdateRetail() {
	param(
        [Parameter(Mandatory=$true)]
        [string] $projectPATH,
		[Parameter(Mandatory=$true)]
        [string] $deployFolder,
        [Parameter(Mandatory=$true)]
        [string] $version
	)

    if(Test-Path "$projectPATH\web"){
        WriteLog -info "Module Web exists ---> Start updating"
        try{
            Get-ChildItem -Path "$projectPATH\$deployFolder\$version\Retail" -Recurse |
            ForEach-Object {
                if(!([System.IO.File]::Exists($_.FullName.Replace("$deployFolder\$version\Retail", "web"))) -or ([System.IO.Directory]::Exists($_.FullName.Replace("$deployFolder\$version", "web"))) ) {
                    Copy-Item -Path $_.FullName -Destination $_.FullName.Replace("$deployFolder\$version\Retail", "web") -Force
                } else {
                    WriteLog -warn "Ignore: $_ -> Already exists in destination"
                }
            }
            WriteLog -info "Success! Web module updated ---> Continue"
        } catch [Exception] {
            WriteLog -error "Error renewing module WEB. Stack trace: $($_.Exception.GetType().FullName), $($_.Exception.Message)" -ErrorAction Stop
        }
        
    }
    if((Test-Path "$projectPATH\www")){
        WriteLog -info "Module Web exists ---> Start updating"
        try{
            Get-ChildItem -Path "$projectPATH\$deployFolder\$version\Retail" -Recurse |
            ForEach-Object {
                if(!([System.IO.File]::Exists($_.FullName.Replace("$deployFolder\$version\Retail", "www"))) -or ([System.IO.Directory]::Exists($_.FullName.Replace("$deployFolder\$version\Retail", "www"))) ) {
                    Copy-Item -Path $_.FullName -Destination $_.FullName.Replace("$deployFolder\$version\Retail", "www") -Force
                } else {
                    WriteLog -warn "Ignore: $_ -> Already exists in destination"
                }
            }

            WriteLog -info "Success! Web module updated ---> Continue"
        } catch [Exception] {
            WriteLog -error "Error renewing module Web. Stack trace: $($_.Exception.GetType().FullName), $($_.Exception.Message)" -ErrorAction Stop
        }
        
    }
}