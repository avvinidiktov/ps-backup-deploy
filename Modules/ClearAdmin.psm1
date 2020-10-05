Function ClearAdmin() {
    Param(
        [Parameter(Mandatory=$true)]
        [string] $projectPATH
    )

    $module_dir = "$projectPATH\admin"
    $excludedList = @("Web.config", "Uploads")

      
        # Remove data in Asset folder without exclude list in this folder 
    if (Test-Path ($module_dir)) {
        Get-ChildItem -Path $module_dir -Exclude $excludedList | foreach ($_) {
            if([System.IO.Directory]::Exists($_.FullName)){
                WriteLog -info "CLEANED... : + $_.fullname"
            }
            Remove-Item $_.fullname -Recurse -Force
        }
    
    WriteLog -info "Remove old data in $module_dir is complete"
    }
}