function recurseCopyFiles() {
	param(
        [Parameter(Mandatory=$true)]
        [string] $projectPATH,
		[Parameter(Mandatory=$true)]
        [string] $tempPATH,
        [Parameter(Mandatory=$true)]
        [string] $version
	)
    
    $tempVar = $_.FullName.Replace("temp\$version", "web")
    $tempVar

    if((Test-Path "$projectPATH\web")){
        $_.FullName
        Get-ChildItem -Path "$tempPATH\Retail" -Recurse |
        For-EachObject {
            $_.FullName
                Copy-Item -Path "$tempPATH\Retail" -Destination $_.FullName.Replace("\temp\$version\Retail", "web") -Verbose
            }
        }
    if((Test-Path "$projectPATH\www")){
        Get-ChildItem -Path "$tempPATH\Retail" -Recurse |
        For-EachObject {
            if(!(Test-Path $_.FullName.Replace("\temp\$version\Retail", "www"))) {
                Copy-Item -Path "$tempPATH\Retail" -Destination $_.FullName.Replace("\temp\$version\Retail", "www") -Verbose
            }
        }
    }
    if((Test-Path "$projectPATH\admin")){
        Get-ChildItem -Path "$tempPATH\Admin" -Recurse |
        For-EachObject {
            if(!(Test-Path $_.FullName.Replace("\temp\$version", ""))) {
                Copy-Item -Path "$tempPATH\Retail" -Destination $_.FullName.Replace("\temp\$version", "") -Verbose
            }
        }
    }
    if((Test-Path "$projectPATH\business")){
        Get-ChildItem -Path "$tempPATH\Business" -Recurse |
        For-EachObject {
            if(!(Test-Path $_.FullName.Replace("\temp\$version", ""))) {
                Copy-Item -Path "$tempPATH\Retail" -Destination $_.FullName.Replace("\temp\$version", "") -Verbose
            }
        }
    }
}

Function Decompress() {
    Param(
        [Parameter(Mandatory=$true)]
        [string] $projectPATH,
        [Parameter(Mandatory=$true)]
        [string] $archivesPATH
    )
		
    if(Test-Path "$archivesPATH") {
        Expand-Archive -LiteralPath "$archivesPATH" -DestinationPath "$projectPATH\temp" -Force
		Get-ChildItem -Path "$projectPATH\temp" |
		ForEach-Object {
			$moduleName = (Split-Path $_ -Leaf)
			
            recurseCopyFiles $projectPATH "$projectPATH\temp\$moduleName" $moduleName
		}
	} else {
        WriteLog -warn "No module named $moduleName"
    }
}