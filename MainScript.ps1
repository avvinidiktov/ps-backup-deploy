Param(
    [switch] $ConfigList = $false
)

if($ConfigList) {
    [xml] $configFile = Get-Content ./Config.xml
    $configFile.configuration.appsettings.add
} else {
    [xml] $config = Get-Content ./Config.xml
	[string] $modulePath = $config.configuration.appsettings.add[0].value
    [string] $projectPATH = $config.configuration.appsettings.add[1].value
	[string] $backupProjectFolder = $config.configuration.appsettings.add[2].value
    [string] $configFilePath = $config.configuration.appsettings.add[3].value
    [string] $backupDbFolder = $config.configuration.appsettings.add[4].value
	[string] $deployFolder = $config.configuration.appsettings.add[5].value
	[string] $archivesPATH = $config.configuration.appsettings.add[6].value
	[string] $branchName = $config.configuration.appsettings.add[7].value
	[string] $global:logFilePATH = $config.configuration.appsettings.add[8].value
	
    #importing Logging module, backup project module, Backup database module, module WriteLog imported global

    Import-Module -Name "./Modules/WriteLog.psm1" -Global
    Import-Module -Name "./Modules/BackupProject.psm1"
    Import-Module -Name "./Modules/BackupDB.psm1"
    Import-Module -Name "./Modules/ExpandArchive.psm1"
    
    try{
        <#
        *EN/US
        * Create backup for all project
        *
        *RU   
        * ������� ����� ��� ����� �������
        #>

        #simple backup for project and DB
        WriteLog -info "Start backuping project"
        WriteLog -error "Start backuping project"
        BackupProject $projectPATH $backupProjectFolder #Done
        WriteLog -info "Backuping project ---> DONE "


        <#
        *EN/US
        * Parse Web.config, using DBname & DBhost to connect remote host and backup DB
        *
        *RU   
        * ������ Web.config, �������� DBhost & DBname ����� ����������� ���������� ����� � ������� ����� ����
        #>

        WriteLog -info "Start backuping Database"
        WriteLog -error "Start backuping Database"
        #BackupDB $configFilePath $backupDbFolder
        WriteLog -info "Backuping Database ---> DONE "

        #pull from vcs in project folder
        WriteLog -info "Start pulling from github: "
        WriteLog -error "Start pulling from github: "
        #git pull origin $branchName
        WriteLog -info "Pulling project ---> DONE "
    
        #publish, pack, get version, archive in temp /archives folder
        WriteLog -info "Start publishing project: "
        WriteLog -error "Start publishing project: "
        #Publish $branchName $modulePath
        WriteLog -info "Publishing project ---> DONE "


        <#
        *EN/US
        * Expand archive with publish modules to the temp folder
        *
        *RU   
        * ������������� ����� � temp ����������
        #>

        WriteLog -info "Start renewing project: "
        WriteLog -error "Start renewing project: "
        ExpandArchive $projectPATH $archivesPATH $backupProjectFolder $deployFolder 
        WriteLog -info "Renewing project ---> DONE "    

        <#
        *EN/US
        * Che�k clients projet folder for existing modules, then importing
        * modules which delete all old binary files. To set exclude list 
        * change var's $excludeList in .psm1 modules.
        *
        *RU   
        * ��������� ���������� ������� �� �������, ����� ���� ����������
        * ������, ��������� ������ ��������� �� ����������� ������ ����������.
        * ����� ������ ���� ���������� ����� �������� ���������� $excludeList
        * ������ .psm1 �������
        #>

        WriteLog -info "Start deploying modules: "
        WriteLog -error "Start deploying modules: "
        if(Test-Path "$projectPATH\admin"){
            WriteLog -error "Start deploying Admin: "
            Import-Module -Name "./Modules/ClearAdmin.psm1"
            ClearAdmin $projectPATH
            WriteLog -error "Updating Admin " 
            Import-Module -Name "./Modules/UpdateAdmin.psm1"
            UpdateAdmin $projectPATH $deployFolder $backupProjectFolder

        }
        if(Test-Path "$projectPATH\business"){
            WriteLog -error "Start deploying Business: "
            Import-Module -Name "./Modules/ClearBusiness.psm1"
            ClearBusiness $projectPATH
            WriteLog -error "Updating Business" 
            Import-Module -Name "./Modules/UpdateBusiness.psm1"
            UpdateBusiness $projectPATH $deployFolder $backupProjectFolder
        }
        if((Test-Path "$projectPATH\web") -or (Test-Path "$projectPATH\www")){
            WriteLog -error "Start deploying Retail: "
            Import-Module -Name "./Modules/ClearWeb.psm1"
            ClearWeb $projectPATH
            WriteLog -error "Updating Retail" 
            Import-Module -Name "./Modules/UpdateRetail.psm1"
            UpdateRetail $projectPATH $deployFolder $backupProjectFolder

        }

        WriteLog -info "Updating modules ---> DONE" 
        WriteLog -info "Deploying modules ---> DONE" 

    } catch [Exception] {
        WriteLog -error "Error in main script, stack trace: $($_.Exception.GetType().FullName), $($_.Exception.Message)" -ErrorAction Stop
    } finally {    
        #logs
        Remove-Module WriteLog
    
        #backups
        Remove-Module BackupProject
        Remove-Module BackupDB

        #Remove-Module publish
        #Remove-Module DeployProject
        Remove-Module ExpandArchive

        #Deploy modules
        Remove-Module ClearAdmin
        Remove-Module ClearBusiness
        Remove-Module ClearWeb
    
        #Update old bins
        Remove-Module UpdateRetail
        Remove-Module UpdateAdmin
        Remove-Module UpdateBusiness
    }
}