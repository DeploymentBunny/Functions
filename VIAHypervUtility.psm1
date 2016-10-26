<#
 #C:\Setup\Module\FAHypervUtil.psm1
#>

Function Test-FAVMSwitchexistence
{
    Param(
        [string]$VMSwitchname
    )
        $Item = (Get-VMSwitch | Where-Object -Property Name -EQ -Value $VMSwitchname).count
        If($Item -eq '1'){Return $true}else{Return $false}
}

Function Test-FAVMexistence
{
    Param(
        [string]$VMname
    )
        $Item = (Get-VM | Where-Object -Property Name -EQ -Value $VMname).count
        If($Item -eq '1'){Return $true}else{Return $false}
}

Function Remove-FAVM
{
[cmdletbinding(SupportsShouldProcess=$True)]
    Param(
    [parameter(mandatory=$True,ValueFromPipelineByPropertyName=$true,Position=0)]
    [ValidateNotNullOrEmpty()]
    $VMName
    )
        $Item = Get-VM -Name $VMName -ErrorAction Stop
        Write-Verbose "Found the sucker..."
        $Item | Stop-VM -Force
        Write-Verbose "Stopped it..."
        $Item | Remove-VM -Force
        Write-Verbose "Killing it..."
        $Item.ConfigurationLocation | Remove-Item -Force -Recurse
        Write-Verbose "Haha, and here goes the data down the drain..."
}

Function Compress-VHD
{
    Param($VHDFile)
    Mount-VHD -Path $VHDFile -NoDriveLetter -ReadOnly
    Optimize-VHD -Path $VHDFile -Mode Full
    Dismount-VHD -Path $VHDFile
}



