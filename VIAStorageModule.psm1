<#
.Synopsis
   VIAUtility.psm1
.DESCRIPTION
   VIAUtility.psm1
.EXAMPLE
   Example of how to use this cmdlet
#>
<#
#>
Function Initialize-VIADataDisk
{
    Param(
        [parameter(position=0,mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('NTFS','ReFS','NA')]
        $FileSystem = 'NTFS',
        $DiskNumber = '1',
        $PartitionType = 'GPT',
        $FileSystemLabel = 'Datadisk01'
    )
    Write-Verbose "Working on disk: $DiskNumber"
    if($FileSystem -eq 'NA'){}else{
        Initialize-Disk -Number $DiskNumber –PartitionStyle $PartitionType
        $Drive = New-Partition -DiskNumber $DiskNumber -GptType '{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}' -UseMaximumSize
        $Drive | Format-Volume -FileSystem $FileSystem -NewFileSystemLabel $FileSystemLabel
        Add-PartitionAccessPath -DiskNumber $DiskNumber -PartitionNumber $Drive.PartitionNumber -AssignDriveLetter
        $Drive = Get-Partition -DiskNumber $DiskNumber -PartitionNumber $Drive.PartitionNumber
    }
}
