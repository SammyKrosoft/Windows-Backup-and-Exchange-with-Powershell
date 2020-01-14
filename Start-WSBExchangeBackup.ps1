<#
.DESCRIPTION
       This is a script closely adapted from the below link:
       https://blog.jasonsherry.net/2013/02/06/windows-backup-script/
       By Jason "Izzy" Sherry

#>
[CmdletBinding()]
Param(
       [String]$Server = $env:computerName,
       [Parameter(Mandatory)][String]$BackupShare = "\\YourServer\Backups\$($env:computername)",
       [string[]]$Databases = @("DB01","DB02","DB03"),
       [switch]$ActiveDBsOnly
)
 
$BackupShare += "\"            #Adding trailing backslash
 
$RequireLocal = $ActiveDBsOnly # If =ActiveDBsOnly switch is specified, the script will skip any DBs that aren't active locally
 
# HKEY_LOCAL_MACHINE\Software\Microsoft\ExchangeServer\v14\Replay\Parameters\EnableVSSWriter = 0
# If the Exchange server host any passive copies this key must be set to 0 or Windows Backup will fail
# Setting this to 0 disables hardware based VSS snapshots, which will break most storage based snapshot solutions

$ResetRegKey = $True # If set to $True the script will set the value back to 1 after the Windows Backup is done
$RegParameters = "HKLM:\Software\Microsoft\ExchangeServer\v15.1\Replay\Parameters"
 
$EnableVSSWriter = (Get-ItemProperty $RegParameters).EnableVSSWriter
 
$Date = Get-Date
 
If ($EnableVSSWriter -ne 0) {
       Write-Host "Setting EnableVSSWriter=0"
       Set-ItemProperty -path $RegParameters -Name "EnableVSSWriter" -value 0 -Type "DWord"
       Write-Host "Restarting the Exchange Replication Service"
       Restart-Service "MSExchangeRepl"
}

ForEach ($Database in $Databases) {
       $CurrentDB = Get-MailboxDatabase $Database
       $DBDrive = $CurrentDB.EdbFilePath.DriveName
       $CurrentServer = $CurrentDB.Server.Name          # Sam-Note: "Server" parameter is the same as the "MountedOnServer"  parameter of the current database.
       If ($CurrentServer -ne $Server -and $RequireLocal) {
              Write-Hose "-ActiveDBsOnly parameter specified => the database $Database is not active on the current server"
              Write-Host "`nBackup aborted, $Database is active on $CurrentServer, which is not the same as the current server: $Server." -ForegroundColor Yellow
       }
       Else {
              Write-Host "Starting backup of database: $Database on drive: $DBDrive" -ForegroundColor Green
              If ($DBDrive -eq $Null) {Exit}
              $BackupPath = $BackupShare + $Database
              $CMDLine = "START BACKUP -backupTarget:" + $BackupPath + " -include:" + $DBDrive +" -vssFull -quiet"
              Write-Verbose "Running: `n wbadmin.exe $CMDLine "
 
              $pinfo = New-Object System.Diagnostics.ProcessStartInfo
              $pinfo.FileName = "wbadmin.exe"
              $pinfo.RedirectStandardError = $True
              $pinfo.RedirectStandardOutput = $True
              $pinfo.UseShellExecute = $false
              $pinfo.Arguments = $CMDLine
              $Process = New-Object System.Diagnostics.Process
              $Process.StartInfo = $pinfo
              $Process.Start() | Out-Null
              $Process.WaitForExit()

              $output = $Process.StandardOutput.ReadToEnd()
              "Backup started: $Date" | Out-File "Backup.log" -Append
              $output | Out-File "Backup.log" -Append

              $ExitCode = $Process.ExitCode
              If ($ExitCode -ne 0) {
                     Write-Host "`nBackup may have not been successful, ExitCode: $ExitCode was returned`n`n" -ForegroundColor Red
                     Write-Host $output
              }
              Else {
                     Write-Host "Backup of database: $Database finished with no errors" -ForegroundColor Green
              }
       }
}
 
If ($ResetRegKey) {
        Write-Host "Setting EnableVSSWriter=1"
        Set-ItemProperty -path $RegParameters -Name "EnableVSSWriter" -value 1 -Type "DWord"
        Write-Host "Restarting the Exchange Replication Service"
        Restart-Service "MSExchangeRepl"
}
