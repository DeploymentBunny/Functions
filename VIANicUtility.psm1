<#
.Synopsis
   FANicUtility.psm1
.DESCRIPTION
   FANicUtility.psm1 is a part of HYDV6
.EXAMPLE
   Example of how to use this cmdlet
#>

function Rename-FANetAdapter
{
<#
.Synopsis
   Rename-FANetAdapter
.DESCRIPTION
   Rename-FANetAdapter is a part of HYDV6
.EXAMPLE
   Example of how to use this cmdlet
#>
    Param(
        [Parameter(Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=0)]
        $NetAdapterMacAddress,

        [Parameter(Mandatory=$true,
            ValueFromPipelineByPropertyName=$true,
            Position=1)]
        $NetAdapterNewName
    )
    Foreach($Item in $NetAdapterMacAddress){
        Write-Host "Looking for $Item"
        $NIC = Get-NetAdapter -Physical | Where-Object -Property MacAddress -EQ -Value $($Item.Replace(":","-"))
        Rename-NetAdapter -InputObject $NIC -NewName $NetAdapterNewName
    }
}
function Disable-FADisconnectedNetAdapter
{
<#
.Synopsis
   FADisconnectedNetAdapter
.DESCRIPTION
   FADisconnectedNetAdapter is a part of HYDV6
.EXAMPLE
   Example of how to use this cmdlet
#>
    $Nics = Get-NetAdapter -Physical | Where-Object -Property Status -EQ -Value Disconnected
    Foreach($Item in $Nics){
        Write-Host "Looking for $Item"
        Disable-NetAdapter -InputObject $Item -Confirm:$false
    }
}
