<#
 #C:\Setup\Module\FAOSUtil.psm1
#>
Function Get-OSVersion{
    $OS = Get-WmiObject -class Win32_OperatingSystem
    Switch ($OS.Version)
    {
    "6.1.7600"
    {
        If($OS.ProductType -eq 1){$OSv = "W7"}Else{$OSv = "WS2008R2"}
    }
    "6.2.9200"
    {
        If($OS.ProductType -eq 1){$OSv = "W8"}Else{$OSv = "WS2012"}
    }
    "6.3.9600"
    {
        If($OS.ProductType -eq 1){$OSv = "W81"}Else{$OSv = "WS2012R2"}
    }
    "10.0.10586"
    {
        If($OS.ProductType -eq 1){$OSv = "W10"}Else{$OSv = "WS2016"}
    }
        DEFAULT {$OSv="Unknown"}
    } 
    Return $OSV
} 
