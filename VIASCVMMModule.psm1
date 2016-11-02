#Import Drivers in SCVMM Lib
Function Import-VIASCVMDriver
{
    param(
        $SCVMMLibPath,
        $LocalDriversPath
    )
    Copy-item -Path "$LocalDriversPath" -Destination "$SCVMMLibPath" -Recurse
    Get-SCLibraryShare | Read-SCLibraryShare
}
Function Set-VIASCVMDriverTag
{
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
Function Install-VIAHPSUM($HostName)
{
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
Function Start-VIAMaintMode($HostName)
{
    #Set in MainMode
    $VMHost = Get-SCVMHost -ComputerName $HostName
    Disable-SCVMHost -VMHost $VMHost -Verbose
    Start-Sleep 2
}
Function Stop-VIAMaintMode($HostName)
{
    #Set in MainMode
    $VMHost = Get-SCVMHost -ComputerName $HostName
    Enable-SCVMHost -VMHost $VMHost -Verbose
    Start-Sleep 2
}
Function Set-VIADisconnectedNicsDisable($HostName)
{
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
function Get-VIASCVMHostRefresh($HostName)
{
    $VMHost = Get-SCVMHost -ComputerName $HostName
    Read-SCVMHost -VMHost $VMHost
    Read-SCVirtualMachine -VMHost $VMHost
    }
function Add-VIAAdmintools($HostName)
{
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
Function Install-VIAProWin64($HostName)
{
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
Function Set-VIAIntelNicForHyperVOnly($HostName)
{
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
Function Install-VIADellOMSU($HostName)
{
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
Function Install-VIADellDriverPackForR730($HostName)
{
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
Function Install-VIADellChipSetDriverForR730($HostName)
{
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
Function Install-VIADellPERC($HostName)
{
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
Function Set-VIALiveMig($HostName,$LiveMigrationSubnets)
{
    $VMHost = Get-SCVMHost -ComputerName $HostName
    Set-SCVMHost -VMHost $vmHost -LiveStorageMigrationMaximum "4" -EnableLiveMigration $true -LiveMigrationMaximum "4" -MigrationPerformanceOption "UseCompression" -MigrationAuthProtocol "CredSSP" -UseAnyMigrationSubnet $false -MigrationSubnet $LiveMigrationSubnets
}
Function Enable-VIARDPAccess
{
        Param(
        $SCVMMHostName
    )    
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
Function Disable-VIARDPSecurity
{
        Param(
        $SCVMMHostName
    )
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
Function Enable-VIARDPFirewallRules
{
    Param(
        $SCVMMHostName
    )

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
Function Install-VIASCVMMHostApplication
{
    Param(
        $SCVMMHostName,
        $Command,
        $Arguments,
        $Reboot
    )

    $VMHost = Get-SCVMHost -ComputerName $SCVMMHostName
    $ScriptSetting = New-SCScriptCommandSetting
    Set-SCScriptCommandSetting -ScriptCommandSetting $scriptSetting -WorkingDirectory "" -PersistStandardOutputPath "" -PersistStandardErrorPath "" -MatchStandardOutput "" -MatchStandardError "" -MatchExitCode "" -WarnAndContinueOnMatch -RestartOnRetry $false -MatchRebootExitCode "{1}|{3010}|{3011}" -RestartScriptOnExitCodeReboot $false -AlwaysReboot $true
    $Arguments = "/c \\fadepl01\ApplicationRoot\Install-PERC\Source\SAS-RAID_Firmware_WN0HC_WN64_25.3.0.0016_A04.EXE /s" 

    Invoke-SCScriptCommand -Executable $Command -TimeoutSeconds 900 -CommandParameters $Arguments -VMHost $VMHost -ScriptCommandSetting $scriptSetting
    $ScriptJob = Get-SCJob -newest 3 | where { $_.Status -eq "Running" -and $_.Name -Like "Invoke script command ($Command $CommandParams)" }
    do {}
    While($scriptjob.status -eq 'Running')
}
