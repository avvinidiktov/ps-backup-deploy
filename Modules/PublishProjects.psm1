Function UpdateVersion() {
	param(
		[string] $branchName,
	)
    $version = $branchName.Split("\")[1]
    (Get-Content -path ".\Utility\Config\GeneralConfiguration.cs") `
    -replace '_appVersion = ".*"', "_appVersion = `"$($version)`"" |
    Out-File .\Utility\Config\GeneralConfiguration.cs
    return $version
}

Function PackModules() {
	param(
		[string] $modulePath
	)

	$DirToExclude=@("node_modules")
	
		cd $modulePath
	
        # Create folder for archives if one of vars exists
        New-Item -ItemType Directory -Force -Path ./archives/

        # Pack Retail
        if (Test-Path "./publish/Retail") {
            echo "Install scripts for Retail"
            cd ./publish/Retail
            npm install
            if($prod) {
                npm run build:prod
            } else {
                npm run build
            }
            Remove-Item -path ./Web.config
            cd ../../
            
        }
        
        # Pack Business
        if (Test-Path "./publish/Business") {
            cd ./publish/Business
            Remove-Item -path ./Web.config
            cd ../../
        }

        # Pack Admin
        if (Test-Path "./publish/Admin") {
            cd ./publish/Admin
            Remove-Item -path ./Web.config
            cd ../../
        }

        Get-ChildItem "./publish/" -Exclude $DirToExclude -Recurse |
                Compress-Archive -DestinationPath "./archives/$version.zip" -Force

            echo "Congrats! Version archive is ready."

        # Remove BusinessLogic folder
        Remove-Item -path ./publish/BusinessLogic -Force -Recurse
    

}

Function Publish() {
	param(
		[string] $branchName,
		[switch] $global:prod = $false,
		[string] $modulePath
	)
	
	cd $modulePath

    $global:version = (UpdateVersion $branchName)
        
    if($prod) {
        echo "Prod Version"
    } else {
        echo "Debug Version"
    }
    
    # Publish 
    if($prod) {
        # TODO create prod profile
        msbuild /p:DeployOnBuild=true /p:PublishProfile=DebugLocal
    } else {
        msbuild /p:DeployOnBuild=true /p:PublishProfile=DebugLocal
    }

    PackModules $modulePath
}