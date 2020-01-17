################################################################################################
# Powershell wbadmin Backup Script
# Author: Martijn Kamminag
# https://www.isee2it.nl
# Date: 13 januari 2018
# Version: 1.1
#
# THIS CODE-SAMPLE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED 
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR 
# FITNESS FOR A PARTICULAR PURPOSE.
#
# This sample is not supported under any Microsoft standard support program or service. 
# The script is provided AS IS without warranty of any kind. Microsoft further disclaims all
# implied warranties including, without limitation, any implied warranties of merchantability
# or of fitness for a particular purpose. The entire risk arising out of the use or performance
# of the sample and documentation remains with you. In no event shall Microsoft, its authors,
# or anyone else involved in the creation, production, or delivery of the script be liable for 
# any damages whatsoever (including, without limitation, damages for loss of business profits, 
# business interruption, loss of business information, or other pecuniary loss) arising out of 
# the use of or inability to use the sample or documentation, even if Microsoft has been advised 
# of the possibility of such damages.
################################################################################################
# Run with Highest Privileges in Scheduled Tasks - aka RunAsAdmin in Powershell
################################################################################################
#
# Example usage: .\backup-script.ps1 .\list.txt
# Remember that list.txt is the file containing a list of Server names to run this against


# Set Weekly and Monthly backups. 7 day' s 1 week and/or 4-5 weeks a month
$Weekly = "No"
$Montly = "Yes"
#Set Up Variables for Sending Mail
$smtpServer = "FQDN/IP"
$subject = "Backup Script Executed on $ComputerName"
$sendfrom = "your@email.com"
$sendTo = "your@email.com"
#Set Variables for Weekday Backup Location
$BackupLocation = "\\X.X.X.X\path\"
# Set the Computer Name Variable
$ComputerName = ${env:computername}

$Path2File = (Get-Item -Path ".\" -Verbose).FullName
$File = "\list.txt"
$ServerListToProcess = $Path2File + $File
    If(!(Test-Path $ServerListToProcess)) { 
        Write-Host "Initial File with Server does not Exists..... creating"
        New-Item $ServerListToProcess -Type File
		Add-Content $ServerListToProcess "$ComputerName"
    }
    else {
    Write-Host $ServerListToProcess
    Write-Host File Allready exists
    }
# Get the Server out of the list.txt file
$computers = get-content $ServerListToProcess #grab the names of the servers/computers to check from the list.txt file.

$FolderToday = "{0:ddd}" -f (get-date)
$Folder1 = "1"
$Folder2 = "2"
$Folder3 = "3"
$Folder4 = "4"
$Folder5 = "5"
$Folder6 = "6"
$Folder7 = "7"

$BackupToday1 = $BackupLocation + $ComputerName + $FolderToday + $Folder1
$BackupToday2 = $BackupLocation + $ComputerName + $FolderToday + $Folder2
$BackupToday3 = $BackupLocation + $ComputerName + $FolderToday + $Folder3
$BackupToday4 = $BackupLocation + $ComputerName + $FolderToday + $Folder4
$BackupToday5 = $BackupLocation + $ComputerName + $FolderToday + $Folder5
$BackupToday6 = $BackupLocation + $ComputerName + $FolderToday + $Folder6
$BackupToday7 = $BackupLocation + $ComputerName + $FolderToday + $Folder7


# Begin schedule
# ----------------------
$date = (date -Hour 0 -Minute 0 -Second 0)
$now = Get-Date
$currentMonth = $now.Month
# ----------------------
$setweekday1 = "Monday"
$setweekday2 = "Tuesday"
$setweekday3 = "Wednesday"
$setweekday4 = "Thursday"
$setweekday5 = "Friday"
$setweekendday6 = "Saturday"
$setweekendday7 = "Sunday"
# ----------------------

# Weekly backup with 7 day's retention
If ($Weekly -eq "Yes") {
# Day 1
if (($date.DayOfWeek -eq $setweekday1) -or ($date.DayOfWeek -eq $setweekday2) -or ($date.DayOfWeek -eq $setweekday3) -or ($date.DayOfWeek -eq $setweekday4) -or ($date.DayOfWeek -eq $setweekday5) -or ($date.DayOfWeek -eq $setweekendday6) -or ($date.DayOfWeek -eq $setweekendday7)) {
	Write-Host Day is $date
	Write-Host Execute your command here
	Remove-Item -Path $BackupToday1 -Force -recurse
	New-Item $BackupToday1 -Type Directory
	$note = "Backup Today: $date"
	C:\Windows\System32\wbadmin.exe start backup -include:c: -backupTarget:$BackupToday1 -quiet
	}
# Day 2
if (($date.DayOfWeek -eq $setweekday1) -or ($date.DayOfWeek -eq $setweekday2) -or ($date.DayOfWeek -eq $setweekday3) -or ($date.DayOfWeek -eq $setweekday4) -or ($date.DayOfWeek -eq $setweekday5) -or ($date.DayOfWeek -eq $setweekendday6) -or ($date.DayOfWeek -eq $setweekendday7)) {
	Write-Host Day is $date
	Write-Host Execute your command here
	Remove-Item -Path $BackupToday2 -Force -recurse
	New-Item $BackupToday2 -Type Directory
	$note = "Backup Today: $date"
	C:\Windows\System32\wbadmin.exe start backup -include:c: -backupTarget:$BackupToday2 -quiet
	}
# Day 3
if (($date.DayOfDay -eq $setweekday1) -or ($date.DayOfWeek -eq $setweekday2) -or ($date.DayOfWeek -eq $setweekday3) -or ($date.DayOfWeek -eq $setweekday4) -or ($date.DayOfWeek -eq $setweekday5) -or ($date.DayOfWeek -eq $setweekendday6) -or ($date.DayOfWeek -eq $setweekendday7)) {
	Write-Host Day is $date
	Write-Host Execute your command here
	Remove-Item -Path $BackupToday3 -Force -recurse
	New-Item $BackupToday3 -Type Directory
	$note = "Backup Today: $date"
	C:\Windows\System32\wbadmin.exe start backup -include:c: -backupTarget:$BackupToday3 -quiet
	}
# Day 4
if (($date.DayOfWeek -eq $setweekday1) -or ($date.DayOfWeek -eq $setweekday2) -or ($date.DayOfWeek -eq $setweekday3) -or ($date.DayOfWeek -eq $setweekday4) -or ($date.DayOfWeek -eq $setweekday5) -or ($date.DayOfWeek -eq $setweekendday6) -or ($date.DayOfWeek -eq $setweekendday7)) {
	Write-Host Day is $date
	Write-Host Execute your command here
	Remove-Item -Path $BackupToday4 -Force -recurse
	New-Item $BackupToday4 -Type Directory
	$note = "Backup Today: $date"
	C:\Windows\System32\wbadmin.exe start backup -include:c: -backupTarget:$BackupToday4 -quiet
	}
# Day 5
if (($date.DayOfWeek -eq $setweekday1) -or ($date.DayOfWeek -eq $setweekday2) -or ($date.DayOfWeek -eq $setweekday3) -or ($date.DayOfWeek -eq $setweekday4) -or ($date.DayOfWeek -eq $setweekday5) -or ($date.DayOfWeek -eq $setweekendday6) -or ($date.DayOfWeek -eq $setweekendday7)) {
	Write-Host Day is $date
	Write-Host Execute your command here
	Remove-Item -Path $BackupToday5 -Force -recurse
	New-Item $BackupToday5 -Type Directory
	$note = "Backup Today (Leap Date): $date"
	C:\Windows\System32\wbadmin.exe start backup -include:c: -backupTarget:$BackupToday5 -quiet
}
# UnComment these 2 if's if you want the week backups to carry on in the weekend (double backup if month is set to yes).
# Day 6
#if (($date.DayOfWeek -eq $setweekday1) -or ($date.DayOfWeek -eq $setweekday2) -or ($date.DayOfWeek -eq $setweekday3) -or ($date.DayOfWeek -eq $setweekday4) -or ($date.DayOfWeek -eq $setweekday5) -or ($date.DayOfWeek -eq $setweekendday6) -or ($date.DayOfWeek -eq $setweekendday7)) {
#	Write-Host Day is $date
#	Write-Host Execute your command here
#	Remove-Item -Path $BackupToday6 -Force -recurse
#	New-Item $BackupToday6 -Type Directory
#	$note = "Backup Today: $date"
#	C:\Windows\System32\wbadmin.exe start backup -include:c: -backupTarget:$BackupToday6 -quiet
#	}
## Day 7
#if (($date.DayOfWeek -eq $setweekday1) -or ($date.DayOfWeek -eq $setweekday2) -or ($date.DayOfWeek -eq $setweekday3) -or ($date.DayOfWeek -eq $setweekday4) -or ($date.DayOfWeek -eq $setweekday5) -or ($date.DayOfWeek -eq $setweekendday6) -or ($date.DayOfWeek -eq $setweekendday7)) {
#	Write-Host Day is $date
#	Write-Host Execute your command here
#	Remove-Item -Path $BackupToday7 -Force -recurse
#	New-Item $BackupToday7 -Type Directory
#	$note = "Backup Today: $date"
#	C:\Windows\System32\wbadmin.exe start backup -include:c: -backupTarget:$BackupToday7 -quiet
#	}

}
else {
Write-Host Weekly backup is set to another value then Yes.
}

# Monthly backup with 5 day retention
If ($Montly -eq "Yes" ) {
# Week 1
if(($date.Day -le 7) -and (($date.DayOfWeek -eq $setweekday1) -or ($date.DayOfWeek -eq $setweekday2) -or ($date.DayOfWeek -eq $setweekday3) -or ($date.DayOfWeek -eq $setweekday4) -or ($date.DayOfWeek -eq $setweekday5) -or ($date.DayOfWeek -eq $setweekendday6) -or ($date.DayOfWeek -eq $setweekendday7))) {
	Write-Host Day is $date
	Write-Host Execute your command here
	Remove-Item -Path $BackupToday1 -Force -recurse
	New-Item $BackupToday1 -Type Directory
	$note = "Backup Today: $date"
	C:\Windows\System32\wbadmin.exe start backup -include:c: -backupTarget:$BackupToday1 -quiet
	}
Else {
	Write-Host This is not a weekday in the first week of the month
	Write-Host $date
	Write-Host Commands need not to be executed
}
# Week 2
if (($date.Day -gt 7) -and ($date.Day -le 14) -and (($date.DayOfWeek -eq $setweekday1) -or ($date.DayOfWeek -eq $setweekday2) -or ($date.DayOfWeek -eq $setweekday3) -or ($date.DayOfWeek -eq $setweekday4) -or ($date.DayOfWeek -eq $setweekday5) -or ($date.DayOfWeek -eq $setweekendday6) -or ($date.DayOfWeek -eq $setweekendday7))) {
	Write-Host Day is $date
	Write-Host Execute your command here
	Remove-Item -Path $BackupToday2 -Force -recurse
	New-Item $BackupToday2 -Type Directory
	$note = "Backup Today: $date"
	C:\Windows\System32\wbadmin.exe start backup -include:c: -backupTarget:$BackupToday2 -quiet
	}
Else {
	Write-Host This is not a weekday in the second week of the month
	Write-Host $date
	Write-Host Commands need not to be executed
}
# Week 3
if(($date.Day -gt 14) -and ($date.Day -le 21) -and (($date.DayOfWeek -eq $setweekday1) -or ($date.DayOfWeek -eq $setweekday2) -or ($date.DayOfWeek -eq $setweekday3) -or ($date.DayOfWeek -eq $setweekday4) -or ($date.DayOfWeek -eq $setweekday5) -or ($date.DayOfWeek -eq $setweekendday6) -or ($date.DayOfWeek -eq $setweekendday7))) {
	Write-Host Day is $date
	Write-Host Execute your command here
	Remove-Item -Path $BackupToday3 -Force -recurse
	New-Item $BackupToday3 -Type Directory
	$note = "Backup Today: $date"
	C:\Windows\System32\wbadmin.exe start backup -include:c: -backupTarget:$BackupToday3 -quiet
	}
Else {
	Write-Host This is not a weekday in the third week of the month
	Write-Host $date
	Write-Host Commands need not to be executed
}
# Week 4
if(($date.Day -gt 21) -and ($date.Day -lt 28) -and (($date.DayOfWeek -eq $setweekday1) -or ($date.DayOfWeek -eq $setweekday2) -or ($date.DayOfWeek -eq $setweekday3) -or ($date.DayOfWeek -eq $setweekday4) -or ($date.DayOfWeek -eq $setweekday5) -or ($date.DayOfWeek -eq $setweekendday6) -or ($date.DayOfWeek -eq $setweekendday7))) {
	Write-Host Day is $date
	Write-Host Execute your command here
	Remove-Item -Path $BackupToday4 -Force -recurse
	New-Item $BackupToday4 -Type Directory
	$note = "Backup Today: $date"
	C:\Windows\System32\wbadmin.exe start backup -include:c: -backupTarget:$BackupToday4 -quiet
	}
Else {
	Write-Host This is not a weekday in the fourth week of the month
	Write-Host $date
	Write-Host Commands need not to be executed
}
# Week 5
if (($date.Day -ge 28) -and ($date.Day -le 31) -and (($date.DayOfWeek -eq $setweekday1) -or ($date.DayOfWeek -eq $setweekday2) -or ($date.DayOfWeek -eq $setweekday3) -or ($date.DayOfWeek -eq $setweekday4) -or ($date.DayOfWeek -eq $setweekday5) -or ($date.DayOfWeek -eq $setweekendday6) -or ($date.DayOfWeek -eq $setweekendday7))) {
	Write-Host Day is $date
	Write-Host Execute your command here
	Remove-Item -Path $BackupToday5 -Force -recurse
	New-Item $BackupToday5 -Type Directory
	$note = "Backup Today: $date"
	C:\Windows\System32\wbadmin.exe start backup -include:c: -backupTarget:$BackupToday5 -quiet
	}
Else {
	Write-Host This is not a weekday in the last week of the month
	Write-Host $date
	Write-Host Commands need not to be executed
}
}
else {
Write-Host Monthly backup is set to other value then Yes.
}
# End schedule

$StartEmailLayout = @"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html><head><title>My Systems Report</title>
<style type="text/css">
<!--
body {
font-family: Verdana, Geneva, Arial, Helvetica, sans-serif;
}

    #report { width: 835px; }

    table{
	border-collapse: collapse;
	border: none;
	font: 10pt Verdana, Geneva, Arial, Helvetica, sans-serif;
	color: black;
	margin-bottom: 10px;
}

    table td{
	font-size: 12px;
	padding-left: 0px;
	padding-right: 20px;
	text-align: left;
}

    table th {
	font-size: 12px;
	font-weight: bold;
	padding-left: 0px;
	padding-right: 20px;
	text-align: left;
}

h2{ clear: both; font-size: 130%; }

h3{
	clear: both;
	font-size: 115%;
	margin-left: 20px;
	margin-top: 30px;
}

p{ margin-left: 20px; font-size: 12px; }

table.list{ float: left; }

    table.list td:nth-child(1){
	font-weight: bold;
	border-right: 1px grey solid;
	text-align: right;
}

table.list td:nth-child(2){ padding-left: 7px; }
table tr:nth-child(even) td:nth-child(even){ background: #CCCCCC; }
table tr:nth-child(odd) td:nth-child(odd){ background: #F2F2F2; }
table tr:nth-child(even) td:nth-child(odd){ background: #DDDDDD; }
table tr:nth-child(odd) td:nth-child(even){ background: #E5E5E5; }
div.column { width: 320px; float: left; }
div.first{ padding-right: 20px; border-right: 1px  grey solid; }
div.second{ margin-left: 30px; }
table{ margin-left: 20px; }
-->
</style>
</head>
<body>

"@

foreach ($computer in $computers) {	

$BackupReport = @()
       $BackupEvent = Get-WinEvent -ComputerName $Computer -LogName "Microsoft-Windows-Backup" -MaxEvents 3
       foreach ($event in $BackupEvent) {
              $row = New-Object -Type PSObject -Property @{
					 Message = $event.Message
					 LevelDisplayName = $event.LevelDisplayName
					 Id = $event.Id
					 TimeCreated = $event.TimeCreated
              }
              $BackupReport += $row
       }
                     
       $BackupReport = $BackupReport | ConvertTo-Html -Fragment

# Setup Mail Format
$bodyinfo = @"
       <hr noshade size=3 width="100%">
       <div id="Backup Report">
       <p><h2>$Computer Backup Report</p></h2>
	   <p><h2>$note</p></h2>      
       <h3>These are the last 3 Backup Log Events</h3>
       <p>The following is a list of the last 3 items <b>Backup log</b> events on $Computer</p>
       <table class="normal">$BackupReport</table>
"@
       # Add the current System HTML Report into the final HTML Report body
       $EventInfo += $bodyinfo
       
       }
$EndEmailLayout = @"
</div>
</body>
</html>
"@	   

# Assemble the final report from all our HTML sections
$Content = $StartEmailLayout + $EventInfo + $EndEmailLayout
# Save the report out to a file in the current path
$DateStr = Get-Date -format "yyyy-MM-dd-hh-mm"
$AbsolutePath = (Get-Item -Path ".\" -Verbose).FullName
$BackupLogsDir = "\BackupLogs"
$LogLocation = $AbsolutePath + $BackupLogsDir
    If(!(Test-Path $LogLocation)) {
        # Folder does NOT Exists
        Write-Host "Initial Backup Log folder does not Exists..... creating"
        New-Item $LogLocation -Type Directory		
    }
$Content | Out-File "$LogLocation\$Computer $DateStr Backup Report.html"
# Email our report out
send-mailmessage -from $sendfrom -to $sendTo -subject "$ComputerName Back-up Report" -BodyAsHTML -body $Content -priority high -smtpServer $smtpServer


# Restore an wbadmin Windows Backup
# 
# BOOT SERVER FROM USB/CD/SERVEREDITION 2008R2/2016
# Boot from CD... / USB ...
# On the Welcome Screen select: Region > Dutch > Keyboard US International > Next
# Repair my PC > Command Prompt
# PROMPT MUST STAY AT: X:\WINDOWS\SYSTEM32\
# cd ..
# cd Windows\System32
# tzutil /l
# tzutil /s "W. Europe Standard Time"
# Wpeutil InitializeNetwork

# net use /user:DOMAIN\Account \\IP\PATH (dns will fail your backup)
# wbadmin get versions -backupTarget:\\IP\PAHT\SRV1za3
# 
# WHERE SRV1za3 IS SERVERNAME > DAY IN 2 LETTER CODE > AND WEEK NUMBER
# REM wbadmin get versions will display the reovery image date and time you need for restore!
# RECOVERY TARGET IS EITHER:  C:\ D:\ E:\
# list the windows directory and you have your recoverytarget
# The next command cannot have additional spaces or the wrong version, if so, the backup will not start!
# 
# wbadmin start recovery -version:03/04/2017-00:01 -backupTarget:\\IP\PATH\SRV1za1 -items:c: -itemtype:volume -recoverytarget:e: