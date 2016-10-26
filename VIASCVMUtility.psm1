#Import Drivers in SCVMM Lib
Function Import-FASCVMDriver{
    param(
        $SCVMMLibPath,
        $LocalDriversPath
    )
    Copy-item -Path "$LocalDriversPath" -Destination "$SCVMMLibPath" -Recurse
    Get-SCLibraryShare | Read-SCLibraryShare
}
Function Set-FASCVMDriverTag{
    Param(
        $TagName,
        $SourceFolder
    )
    $Inffiles = Get-ChildItem -Path $SourceFolder -filter *.inf -Recurse
    foreach ($Inffile in $Inffiles)
    {
        $DriverFile = $Inffile.FullName
        $DriverPackage = Get-SCDriverPackage | Where-Object {$_.SharePath -eq $DriverFile}
        $DriverPackage.SharePath
        Set-SCDriverPackage -DriverPackage $DriverPackage -Tag $TagName -RunAsynchronously
    }
}
Function Install-HPSUM($HostName){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    $scriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $True
    $CommandParams = "/c PowerShell.exe -ExecutionPolicy Bypass -File \\fadepl01\ApplicationRoot\install-HPSUM\Install-HPSUM.ps1" 
    $Command = "CMD.exe"
    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 1800 -CommandParameters $CommandParams -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
Function Start-FAMaintMode($HostName){
    #Set in MainMode
    $VMHost = Get-SCVMHost -ComputerName $HostName
    Disable-SCVMHost -VMHost $VMHost -Verbose
    Start-Sleep 2
}
Function Stop-FAMaintMode($HostName){
    #Set in MainMode
    $VMHost = Get-SCVMHost -ComputerName $HostName
    Enable-SCVMHost -VMHost $VMHost -Verbose
    Start-Sleep 2
}
Function Set-FADisconnectedNicsDisable($HostName){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    $scriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $false
    $CommandParams = "/c PowerShell.exe -ExecutionPolicy Bypass -File \\fadepl01\ApplicationRoot\Maint\SetFADisconnectedNicsDisable.ps1" 
    $Command = "CMD.exe"
    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 60 -CommandParameters $CommandParams -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
function Get-FASCVMHostRefresh($HostName){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    Read-SCVMHost -VMHost $VMHost
    Read-SCVirtualMachine -VMHost $VMHost
    }
function Add-FAAdmintools($HostName){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    $scriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $false
    $CommandParams = "/c powershell.exe -Command Add-WindowsFeature -Name RSAT-Hyper-V-Tools" 
    $Command = "CMD.exe"
    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 120 -CommandParameters $CommandParams -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
Function Install-FAProWin64($HostName){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    $scriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $false
    $CommandParams = "/c \\fadepl01\ApplicationRoot\Install-ProWin64\Source\APPS\PROSETDX\Winx64\DxSetup.exe /qn " 
    $Command = "CMD.exe"
    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 900 -CommandParameters $CommandParams -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
Function Set-FAIntelNicForHyperVOnly($HostName){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    $scriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $false
    $CommandParams = "/c PowerShell.exe -ExecutionPolicy Bypass -File \\fadepl01\ApplicationRoot\Maint\SetFAIntelNicForHyperVOnly.ps1" 
    $Command = "CMD.exe"
    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 240 -CommandParameters $CommandParams -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
Function Install-FADellOMSU($HostName){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    $scriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $false
    $CommandParams = "/c msiexec.exe /i \\fadepl01\ApplicationRoot\Install-HardwareApps\Source\Dell\OMSU\OpenManage\windows\SystemsManagementx64\SysMgmtx64.msi /qb" 
    $Command = "CMD.exe"
    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 900 -CommandParameters $CommandParams -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
Function Install-FADellDriverPackForR730($HostName){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    $scriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $false
    $CommandParams = "/c \\fadepl01\ApplicationRoot\Install-Drivers\Source\Dell\Drivers-for-OS-Deployment_Application_TPJWF_WN64_15.04.07_A00.EXE /s" 
    $Command = "CMD.exe"
    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 900 -CommandParameters $CommandParams -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
Function Install-FADellChipSetDriverForR730($HostName){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    $scriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $false
    $CommandParams = "/c \\fadepl01\ApplicationRoot\Install-Drivers\Source\Dell\Chipset_Driver_1MM6C_WN_9.4.2.1019_A02\Setup.exe /s /v/qn" 
    $Command = "CMD.exe"
    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 900 -CommandParameters $CommandParams -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
Function Install-FADellPERC($HostName){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    $scriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $true
    $CommandParams = "/c \\fadepl01\ApplicationRoot\Install-PERC\Source\SAS-RAID_Driver_2D7H2_WN64_6.602.07.00_A00.EXE /s" 
    $Command = "CMD.exe"
    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 900 -CommandParameters $CommandParams -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
Function Install-FADellPERCFW($HostName){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    $scriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $true
    $CommandParams = "/c \\fadepl01\ApplicationRoot\Install-PERC\Source\SAS-RAID_Firmware_WN0HC_WN64_25.3.0.0016_A04.EXE /s" 
    $Command = "CMD.exe"
    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 900 -CommandParameters $CommandParams -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
Function Set-FALiveMig($HostName,$LiveMigrationSubnets){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    Set-SCVMHost -VMHost $vmHost -LiveStorageMigrationMaximum "4" -EnableLiveMigration $true -LiveMigrationMaximum "4" -MigrationPerformanceOption "UseCompression" -MigrationAuthProtocol "CredSSP" -UseAnyMigrationSubnet $false -MigrationSubnet $LiveMigrationSubnets
}
Function Show-FASText($Text,$Color){
    Write-Host $Text -ForegroundColor $Color
}
Function Restart-FAComputer($Hostname){
    Restart-Computer -ComputerName $Hostname -Force -AsJob
}
Function Enable-RDPAccess($hostname){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    $scriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $false
    $CommandParams = "/c cscript.exe C:\windows\system32\SCregEdit.wsf /AR 0" 
    $Command = "CMD.exe"
    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 900 -CommandParameters $CommandParams -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
Function Disable-RDPSecurity($hostname){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    $scriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $false
    $CommandParams = "/c cscript.exe C:\windows\system32\SCregEdit.wsf /CS 0" 
    $Command = "CMD.exe"
    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 900 -CommandParameters $CommandParams -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
Function Enable-RDPFirewallRules($hostname){
    $VMHost = Get-SCVMHost -ComputerName $HostName
    $scriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $false
    $CommandParams = '/c PowerShell.exe -Command "Get-NetFirewallRule | Where-Object -Property DisplayName -like -Value "*Remote*" | Enable-NetFirewallRule"'
    $Command = "CMD.exe"
    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 900 -CommandParameters $CommandParams -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
Function Install-SNMP($hostname){
    Add-WindowsFeature -Name SNMP-Service -IncludeAllSubFeature -IncludeManagementTools -ComputerName $hostname
    }
Function Install-DCB
{
    Param(
        $Hostname
    )
    Foreach($Item in $Hostname){
        Invoke-Command -ComputerName $Item -ScriptBlock {
            Add-WindowsFeature -Name Data-Center-Bridging -IncludeAllSubFeature -IncludeManagementTools
        }
    }
}
