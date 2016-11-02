<#
.Synopsis
   VIAUtility.psm1
.DESCRIPTION
   VIAUtility.psm1
.EXAMPLE
   Example of how to use this cmdlet
#>
Function Invoke-VIAExe
{
    [CmdletBinding(SupportsShouldProcess=$true)]

    param(
        [parameter(mandatory=$true,position=0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Executable,

        [parameter(mandatory=$true,position=1)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Arguments,

        [parameter(mandatory=$false,position=2)]
        [ValidateNotNullOrEmpty()]
        [int]
        $SuccessfulReturnCode = 0
    )

    Write-Verbose "Running $ReturnFromEXE = Start-Process -FilePath $Executable -ArgumentList $Arguments -NoNewWindow -Wait -Passthru"
    $ReturnFromEXE = Start-Process -FilePath $Executable -ArgumentList $Arguments -NoNewWindow -Wait -Passthru

    Write-Verbose "Returncode is $($ReturnFromEXE.ExitCode)"

    if(!($ReturnFromEXE.ExitCode -eq $SuccessfulReturnCode)) {
        throw "$Executable failed with code $($ReturnFromEXE.ExitCode)"
    }
}
Function Compress-VIADeDupDrive
{
    Param(
        $DriveLetter
    )
    Foreach($Item in $DriveLetter){
        $Drive = $DriveLetter + ":"
        Start-DedupJob $Drive -Type Optimization -Priority High -Memory 75 -Wait
        Start-DedupJob $Drive -Type GarbageCollection -Priority High -Memory 75 -Wait
        Start-DedupJob $Drive -Type Scrubbing -Priority High -Memory 75 -Wait
    }
}
Function Enable-VIACredSSP
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        $Connection
    )

    #Enable CredSSP on Client
    Enable-WSManCredSSP -Role Client -DelegateComputer $Connection -Force -ErrorAction Stop
    Set-Item WSMan:\localhost\Client\AllowUnencrypted -Value $true -Force
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value * -Force -Concatenate
}
Function Get-VIAOSVersion
{
    $OS = Get-WmiObject -Class Win32_OperatingSystem
    $OSversion = [System.Environment]::OSVersion.Version
    $OSversionComplete = "$($version.major).$($version.Minor).$($version.build)"
    $OSversionMajorMinor = "$($version.major).$($version.Minor)"
    $OSversionMajor = "$($version.major).$($version.Minor)"


    Switch ($OSversionMajor)
    {
    "6.1"
    {
        If($OS.ProductType -eq 1){$OSv = "W7"}Else{$OSv = "WS2008R2"}
    }
    "6.2"
    {
        If($OS.ProductType -eq 1){$OSv = "W8"}Else{$OSv = "WS2012"}
    }
    "6.3"
    {
        If($OS.ProductType -eq 1){$OSv = "W81"}Else{$OSv = "WS2012R2"}
    }
    "10.0"
    {
        If($OS.ProductType -eq 1){$OSv = "W10"}Else{$OSv = "WS2016"}
    }
        DEFAULT {$OSv="Unknown"}
    } 
    Return $OSV
}
Function Install-VIASNMP
{
    Param(
        $ComputerName
    )
    Foreach($Item in $ComputerName){
        Invoke-Command -ComputerName $Item -ScriptBlock {
            Add-WindowsFeature -Name SNMP-Service -IncludeAllSubFeature -IncludeManagementTools
        }
    }
}
Function Install-VIADCB
{
    Param(
        $ComputerName
    )
    Foreach($Item in $ComputerName){
        Invoke-Command -ComputerName $Item -ScriptBlock {
            Add-WindowsFeature -Name Data-Center-Bridging -IncludeAllSubFeature -IncludeManagementTools
        }
    }
}
Function Restart-VIAComputer
{
    Param(
        $ComputerName
    )
    Foreach($Item in $ComputerName){
        Restart-Computer -ComputerName $ComputerName -Force -AsJob
    }
}
Function Show-VIAText($Text,$Color)
{
    Write-Host $Text -ForegroundColor $Color
}