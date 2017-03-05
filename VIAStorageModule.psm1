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
Function New-VIAVHD
{
    [CmdletBinding(SupportsShouldProcess=$true)]

    Param(
    [Parameter(Position=0)]
    [ValidateNotNullOrEmpty()]
    [string]
    $VHDFile,

    [Parameter(Position=1)]
    [ValidateNotNullOrEmpty()]
    [string]
    $VHDSizeinMB,

    [Parameter(Position=2)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet('EXPANDABLE','FIXED')]
    [string]
    $VHDType
    )

    if(!(Test-Path -Path ($VHDFile | Split-Path -Parent))){
        throw "Folder does not exists..."}
    
    #Check if file exists
    if(Test-Path -Path $VHDFile){
        throw "File exists..."}

    $diskpartcmd = New-Item -Path $env:TEMP\diskpartcmd.txt -ItemType File -Force
    Set-Content -Path $diskpartcmd -Value "CREATE VDISK FILE=""$VHDFile"" MAXIMUM=$VHDSizeinMB TYPE=$VHDType"
    $Exe = "DiskPart.exe"
    $Args = "-s $($diskpartcmd.FullName)"
    Invoke-Exe -Executable $Exe -Arguments $Args -SuccessfulReturnCode 0
    Remove-Item $diskpartcmd -Force -ErrorAction SilentlyContinue
}
