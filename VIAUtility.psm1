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
Function Convert-VIASubnet
{
    <#
    .SYNOPSIS
    Converts between PrefixLength and subnet mask. 


    .DESCRIPTION
    This script converts between PrefixLength and subnet mask parameters, these parameters define the size of a subnet for IPv4 addresses.  
    This script assumes valid subnet mask input and does not support scenarios such as non-contiguous subnet masks. 


    .INPUTS
    None

    .OUTPUTS
    The script outputs a PrefixLength if SubnetMask was entered, or a SubnetMask if a PrefixLength was entered.

    .NOTES
    Requires Windows 8 or later.

    #>


    param( 

        [Parameter(ParameterSetName="SubnetMask",Mandatory=$True)][string]$SubnetMask, 
        [Parameter(ParameterSetName="PrefixLength",Mandatory=$True)][int]$PrefixLength)


    ####################################
    #User provided a prefix
    if ($PrefixLength)
    {
        $PrefixLengthReturn = $PrefixLength
        if ($PrefixLength -gt 32) 
        { 
            write-host "Invalid input, prefix length must be less than 32"
            exit(1)
        }
               
        $bitArray=""
        for($bitCount = 0; $PrefixLength -ne "0"; $bitCount++) 
        {
            $bitArray += '1'
            $PrefixLength = $PrefixLength - 1;
        }
    
        ####################################                       
        #Fill in the rest with zeroes
        While ($bitCount -ne 32) 
        {
            $bitArray += '0'
            $bitCount++ 
        }
        ####################################
        #Convert the bit array into subnet mask
        $ClassAAddress = $bitArray.SubString(0,8)
        $ClassAAddress = [Convert]::ToUInt32($ClassAAddress, 2)
        $ClassBAddress = $bitArray.SubString(8,8)
        $ClassBAddress = [Convert]::ToUInt32($ClassBAddress, 2)
        $ClassCAddress = $bitArray.SubString(16,8)
        $ClassCAddress = [Convert]::ToUInt32($ClassCAddress, 2)
        $ClassDAddress = $bitArray.SubString(24,8)           
        $ClassDAddress = [Convert]::ToUInt32($ClassDAddress, 2)
 
        $SubnetMaskReturn =  "$ClassAAddress.$ClassBAddress.$ClassCAddress.$ClassDAddress"
    }

    ####################################
    ##User provided a subnet mask
    if ($SubnetMask)
    {
	    ####################################
        #Ensure valid IP address input.  Note this does not check for non-contiguous subnet masks!
        $Address=[System.Net.IPaddress]"0.0.0.0"
        Try
        {
            $IsValidInput=[System.Net.IPaddress]::TryParse($SubnetMask, [ref]$Address)
        }
        Catch 
        {

        }
        Finally
        {

        }    

        if ($IsValidInput -eq $False)
        {
            Write-Host "Invalid Input. Please enter a properly formatted subnet mask."
            Exit(1)
        }

        ####################################
        #Convert subnet mask to prefix length
        If($IsValidInput)
        {
            $PrefixArray=@()
            $PrefixLength = 0
            $ByteArray = $SubnetMask.Split(".")
        
            ####################################        
            #This loop converts the bytes to bits, add zeroes when necessary
            for($byteCount = 0; $byteCount-lt 4; $byteCount++) 
            {
                $bitVariable = $ByteArray[$byteCount]
                $bitVariable = [Convert]::ToString($bitVariable, 2)
            
                if($bitVariable.Length -lt 8)
                {
                  $NumOnes=$bitVariable.Length
                  $NumZeroes=8-$bitVariable.Length

                  for($bitCount=0; $bitCount -lt $NumZeroes; $bitCount++) 
                  {
                    $Temp=$Temp+"0"
                  }
              
                  $bitVariable=$Temp+$bitVariable
                }
            
                ####################################
                #This loop counts the bits in the prefix
                for($bitCount=0; $bitCount -lt 8; $bitCount++) 
                {
                    if ($bitVariable[$bitCount] -eq "1")
                    {
                        $PrefixLength++ 
                    }

                    $PrefixArray=$PrefixArray + ($bitVariable[$bitCount])

                }
            }
        
            ####################################
            #Check if the subnet mask was contiguous, fail if it wasn't.
            $Mark=$False

            foreach ($bit in $PrefixArray) 
            {
                if($bit -eq "0")
                {
                    if($Mark -eq $False)
                    {
                        $Mark=$True
                    }
                }
                if($bit -eq "1")
                {
                    if($Mark -eq $True)
                    {
                        Write-Host "Invalid Input. Please enter a properly formatted subnet mask."
                        Exit(1)
                    }    
                }
                
            }

	        $SubnetMaskReturn = $SubnetMask
	        $PrefixLengthReturn = $PrefixLength
	    }
    }
    ##Create the object to be returned to the console
    $Return = new-object Object
    Add-Member -InputObject $Return -Name PrefixLength -Value $PrefixLengthReturn -Type NoteProperty
    Add-Member -InputObject $Return -Name SubnetMask -Value  $SubnetMaskReturn -Type NoteProperty
    $Return
}
Function Compress-VIADeDupDrive
{
    Param($DriveLetter)
    Get-DedupStatus
    $Drive = $DriveLetter + ":"
    $Drive
    Start-DedupJob $Drive -Type Optimization -Priority High -Memory 75 -Wait
    Start-DedupJob $Drive -Type GarbageCollection -Priority High -Memory 75 -Wait
    Start-DedupJob $Drive -Type Scrubbing -Priority High -Memory 75 -Wait
    Get-DedupStatus
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
