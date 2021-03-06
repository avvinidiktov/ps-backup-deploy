Function DeployModule() {
    Param(
        [Parameter(Mandatory=$true, Position=0)]
        [string] $projectPATH,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $moduleName
    )

    if (Test-Path "$projectPath\$moduleName") {
        switch($moduleName.ToLower()){
            "admin" {
                echo "Manage aplication folder for current project does exist"

                Get-ChildItem -Path "$projectPath\$moduleName" -Exclude Web.config |
                Select -ExpandProperty FullName |
                Where {$_ -notlike "$projectPath\$moduleName\Uploads"} |
                sort length -Descending |
                Remove-Item -Force -Recurse

                echo "Congrats. Old data admin application for current project has deleted"
                Break
            }
            "business" {
                echo "Business aplication folder for current project does exist"
                Get-ChildItem -Path  "$projectPath\$moduleName" -Exclude Web.config |
                Select -ExpandProperty FullName |
                sort length -Descending |
                Remove-Item -Force -Recurse
                echo "Congrats. Old data business application for current project has deleted"
                Break
            }
            "web" {
                echo "Web aplication folder for current project does exist"
                Get-ChildItem -Path  "$projectPath\$moduleName" -Exclude Web.config |
                Select -ExpandProperty FullName |
                Where {($_ -notlike "$projectPath\$moduleName\Assets")} |
                sort length -Descending |
                Remove-Item -Force -Recurse

                Get-ChildItem -Path "$projectPath\$moduleName\Assets" |
                Select -ExpandProperty FullName |
                Where {($_ -notlike "$projectPath\$moduleName\Assets\images") -and ($_ -notlike "$projectPath\$moduleName\Assets\img") -and ($_ -notlike "$projectPath\$moduleName\Assets\files") -and ($_ -notlike "$projectPath\$moduleName\Assets\video")} |
                sort length -Descending |
                Remove-Item -Force -Recurse
                echo "Congrats. Old data web application for current project has deleted"
                Break
            }
            "www" {
                echo "Web aplication folder for current project does exist"
                Get-ChildItem -Path  "$projectPath\$moduleName" -Exclude Web.config |
                Select -ExpandProperty FullName |
                Where {($_ -notlike "$projectPath\$moduleName\Assets")} |
                sort length -Descending |
                Remove-Item -Force -Recurse

                Get-ChildItem -Path "$projectPath\$moduleName\Assets" |
                Select -ExpandProperty FullName |
                Where {($_ -notlike "$projectPath\$moduleName\Assets\images") -and ($_ -notlike "$projectPath\$moduleName\Assets\img") -and ($_ -notlike "$projectPath\$moduleName\Assets\files") -and ($_ -notlike "$projectPath\$moduleName\Assets\video")} |
                sort length -Descending |
                Remove-Item -Force -Recurse
                echo "Congrats. Old data web application for current project has deleted"
                Break
            }
            Default {
                echo "Module $moduleName does not exists. Check moduleNames[] var"
            }
        }    
    }
}

Function DeployModules() {
    Param(
    [Parameter(Mandatory=$true, Position=0)]
    [string] $projectPATH,
    [string[]] $moduleNames = ("admin","business","www","web")
    )

    foreach ($moduleName in $moduleNames) {
        DeployModule $projectPATH $moduleName
    }
}