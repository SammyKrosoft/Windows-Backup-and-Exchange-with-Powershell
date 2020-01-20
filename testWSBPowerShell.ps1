<#
.DESCRIPTION
    Using WindowsServerBackup module to set up and run Exchange backup.
    NOTE: a prerequisite for this is to install Windows Server Backup feature in Windows 2012/2016 server.
    All the below command lines and comments are taken from the link specified in the below LINK section.

.LINK
    https://docs.microsoft.com/en-us/powershell/module/windowserverbackup/set-wbpolicy?view=winserver2012r2-ps

#>

#region Initialize Variables
# Original command line used with wbadmin.exe (just for reference to get the same logic with PowerShell WBS)
$CMDLine = "START BACKUP -backupTarget:" + $BackupPath + " -include:" + $DBDrive +" -vssFull -quiet"
# Target backup path
$BackupPath = "C:\ExchangeVolumes\ExVol3"


#Getting paths to databases to backup (uncomment to backup all databases)
$Databases = Get-MailboxDatabase
$DatabasePaths = $Databases | % {$_.EdbFilePath.PathName}
#$DatabasePathTest = "C:\ExchangeDatabases\DAG1-DB2\DAG1-DB2.db\DAG1-DB2.edb"
#endregion Finished initializing variables
$DatabasePaths
exit
# Prerequisite: add Windows Server Backup feature
Add-WindowsFeature "Windows-Server-Backup"

#Step 1 - creating a backup policy object and stores it in the $Policy variable
$Policy = New-WBPolicy
#Step 5 - get Windows Backup disk configuration for backup destination (if local disk)
#This gets the list of internal and external disks available for the local computer and stores the results in the $Disks variable for re-use
#$Disks = Get-WBDisk
#$Disks
#NOTE: We can specify the volume path directly as well
$BackupPath = "C:\ExchangeVolumes\ExVol3"

Foreach ($DatabasePAth in $DatabasePaths) {
    #Step 2 - create a file specification object and stores the result in the $FileSpec variable.
    #a File Specification determines whaat items to include or exclude from backups
    $FileSpec = New-WBFileSpec -FileSpec $DatabasePath
    #Step 3: Then we have to add this file specification to the backup policy object:
    Add-WBFileSpec -Policy $Policy -FileSpec $FileSpec
 }

    #Step 4 - Adding bare metal recovery to the policy (I won't do it for my test)
    #Add-WBBareMetalRecovery $Policy

    #Step 5 - create a backup target object and store it in a $BackupTarget variable
    #NOTE: we use a variable to store it because If we don't , the backup target object is just invoked and then lost
    $BackupTarget = New-WBBackupTarget -VolumePath $BackupPath
    #Just renaming the $BackupTarget variable to $BackupLocation (wbadmin.exe uses the -backupTarget parameter, and I wanted to stick to wbadmin.exe for easier comparing between the executable and the command line
    $BackupLocation = $BackupTarget

    #Step 7 - command adds the above created backup target to the backup policy we created on step 1 ($policy = New-WBPolicy)
    Add-WBBackupTarget -Policy $Policy -Target $BackupLocation

    #The seventh bis sets the backup as a VSSFull backup (just like the wbadmin.exe command line)
    Set-WBVssBackupOption -Policy $Policy -VssFullBackup
    #Step 8 - set backup schedule inside the policy. This sets the time to create daily backups
    Set-WBSchedule -Policy $Policy -Schedule $(Get-Date)

    #Step 9 - set the backup policy object for the computer
    Set-WBPolicy -Policy $Policy

 Start-WBBackup -policy $Policy
