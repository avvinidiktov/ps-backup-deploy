<#
*EN-US
*To write logs, change var $logFilePATH to your, and use switches to write logs:
*
*    "WriteLog -warn <message>"    -    will write warning logs in format:    WARNING: [TIMESTAMP] - [MESSAGE]
*    "WriteLog -error <message>"   -   will write warning logs:               ERROR: [TIMESTAMP] - [MESSAGE]
*    "WriteLog -info <message>"    -    will info warning logs:               INFO: [TIMESTAMP] - [MESSAGE]
*
*To execute function use: WriteLog <-error/warn/info> <message>
*
*------
*RU
*
* Чтобы записывать логи в нужную директорию измените переменную $logFilePATH на нужный вам путь к лог файлам, типы записываемых логов устанавливаются при помоци [switch]:
*
*    "WriteLog -warn <message>"    -    запишет error лог в формате:    WARNING: [TIMESTAMP] - [MESSAGE]
*    "WriteLog -error <message>"   -    запишет warn лог в формате:     ERROR: [TIMESTAMP] - [MESSAGE]
*    "WriteLog -info <message>"    -    запишет info лог в формате:     INFO: [TIMESTAMP] - [MESSAGE]
*
* Для запуска функции используйте WriteLog <-error/warn/info> <message>
*
#>
Function WriteLog() {
    Param(
    [switch] $help = $false,
    [switch] $warn = $false,
    [switch] $error = $false,
    [switch] $info = $false,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$message,
	[string]$logFilePATH = $global:logFilePATH,
    [string]$timestamp = (Get-Date -format yyyy-MM-dd:hh-mm-ss),
    [string]$InfoLog = "$logFilePATH\INFO.log",
    [string]$WarnLog = "$logFilePATH\WARN.log",
    [string]$ErrorLog = "$logFilePATH\ERROR.log"
    )

    if($help) {
        echo "-warn   -   to write warn log"
        echo "-error  -   to write error log"
        echo "-info   -   to write info log"
    }

    if(($warn) -and !(Test-Path $WarnLog)){
        New-Item -ItemType File -Path $WarnLog -Force
    }
    if(($error) -and !(Test-Path $ErrorLog)){
        New-Item -ItemType File -Path $ErrorLog -Force
    }
    if(($info) -and !(Test-Path $InfoLog)){
        New-Item -ItemType File -Path $InfoLog -Force
    }

    if($warn){
        $message = "WARNING: $timestamp - $message"
        Add-content -Path $WarnLog -value $message
    }
    if($error){
        $message = "ERROR: $timestamp - $message"
        Add-content $ErrorLog -value $message
    }
    if($info){
        $message = "INFO: $timestamp - $message"
        Add-content $InfoLog -value $message
    }
}