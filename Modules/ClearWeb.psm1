Function ClearWeb() {
    Param(
        [Parameter(Mandatory=$true)]
        [string] $projectPATH
    )

    $module_dirs = @("$projectPATH\web", "$projectPATH\www")
    $excludedListWeb = @("Web.config", "Assets")
    $excludedListAssets = @("img", "images", "video", "files")
      
    foreach($module_dir in $module_dirs) {
        if(Test-Path $module_dir){
            Get-ChildItem -Path $module_dir -Exclude $excludedListWeb | foreach ($_) {
                if([System.IO.Directory]::Exists($_.FullName)){
                    WriteLog -info "CLEARED... : + $_.fullname"
                }

                Remove-Item $_.fullname -Recurse -Force
            }

            Get-ChildItem -Path "$module_dir\Assets" -Exclude $excludedListAssets | foreach ($_) {
                if([System.IO.Directory]::Exists($_.FullName)){
                    WriteLog -info "CLEARED... : + $_.fullname"
                }

                Remove-Item $_.fullname -Recurse -Force
            }
    
        WriteLog -info "Remove old data in $module_dir is complete"
        }
    }
}