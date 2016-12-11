Function Get-VIAXMLFabricData
{
    [cmdletbinding(SupportsShouldProcess=$True)]
    
    Param(
        [ValidateSet('Customers','CommonSettings','ProductKeys','Networks','Domains','Servers','Certificates','VHDs','Roles','Services')]
        $Class,

        [switch]$Active,

        $SettingsFile = $SettingsFile

    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    switch ($Class)
    {
        'Customers'{
            $XMLData  = $Settings.FABRIC.Customers.Customer
            }
        'CommonSettings'{
            $XMLData  = $Settings.FABRIC.CommonSettings.CommonSetting
            }
        'ProductKeys'{
            $XMLData  = $Settings.FABRIC.ProductKeys.ProductKey
            }
        'Networks'{
            $XMLData  = $Settings.FABRIC.Networks.Network
            }
        'Domains'{
            $XMLData  = $Settings.FABRIC.Domains.Domain
            }
        'Servers'{
            $XMLData  = $Settings.FABRIC.Servers.Server
            }
        'BuildServers'{
            $XMLData  = $Settings.FABRIC.BuildServers.BuildServer
            }
        'Certificates'{
            $XMLData  = $Settings.FABRIC.Certificates.Certificate
        }
        'VHDs'{
            $XMLData  = $Settings.FABRIC.VHDs.VHD
        }
        'Roles'{
            $XMLData  = $Settings.FABRIC.Roles.Role
        }
        'Services'{
            $XMLData  = $Settings.FABRIC.Services.Service
        }
        Default {
            $XMLData  = $Settings.FABRIC
            }
    }
    $Return = $XMLData
    if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
}
Function Get-VIAXMLFabricCustomer
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=1,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $XMLData  = $Settings.FABRIC.Customers.Customer | Where-Object Id -EQ $id

    $Item = $XMLData
    $Data = [ordered]@{
        Id = $Item.id
        Name = $Item.Name
        Contact = $Item.Contact
        OptionalData = $Item.OptionalData
        Active = $Item.Active
        }
    $Return = New-Object -TypeName psobject -Property $Data
    if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
}
Function Get-VIAXMLFabricCommonSetting
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=1,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $XMLData  = $Settings.FABRIC.CommonSettings.CommonSetting | Where-Object Id -EQ $id
    
    $Item = $XMLData
    $Data = [ordered]@{
        id = $item.id
        Name = $item.Name
        Active = $Item.Active
        MajorVersion = $Item.MajorVersion
        MinorVersion = $Item.MinorVersion
        Solution = $Item.Solution
        CodeName = $Item.CodeName
        LocalPassword = $Item.LocalName
        OrgName = $Item.OrgName
        FullName = $Item.FullName
        TimeZoneName = $Item.TimeZoneName
        InputLocale = $Item.InputLocale
        SystemLocale = $Item.SystemLocale
        UILanguage = $Item.UILanguage
        UserLocale = $Item.UserLocale
        VMSwitchName = $Item.VMSwitchName
        WorkgroupName = $Item.WorkgroupName
        VHDSize = $Item.VHDSize
        OptionalData = $Item.OptionalData
        PasswordUpdated = $Item.PasswordUpdated
        }
    $Return = New-Object -TypeName psobject -Property $Data
    if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
}
Function Get-VIAXMLFabricProductKey
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=1,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $XMLData  = $Settings.FABRIC.ProductKeys.ProductKey | Where-Object Id -EQ $id
    
    $Return = foreach($Item in $XMLData){
        $Data = [ordered]@{
            Id = $Item.Id;
            Name = $Item.Name;
            Key = $Item.Key;
            Active = $Item.Active;
        }
        New-Object -TypeName psobject -Property $Data
    }
    if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
}
Function Get-VIAXMLFabricNetwork
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=1,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $XMLData  = $Settings.FABRIC.Networks.Network | Where-Object Id -EQ $id

    $Return = foreach($Item in $XMLData){
        $Data = [ordered]@{
            id = $item.id
            Name = $item.Name
            NetIP = $item.NetIP
            Gateway = $item.Gateway
            DNS = $item.DNS
            SubNet = $item.SubNet
            VMMStart = $item.VMMStart
            VMMEnd = $item.VMMEnd
            VMMReserv = $item.VMMReserv
            DHCPStart = $item.DHCPStart
            DHCPEnd = $item.DHCPEnd
            DHCPReserv = $item.DHCPReserv
            VLAN = $item.VLAN
            RDNS = $item.RDNS
            OptionalData = $item.OptionalData
            Active = $item.Active
        }
        New-Object -TypeName psobject -Property $Data
    }
    if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
}
Function Get-VIAXMLFabricDomain
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=1,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $XMLData  = $Settings.FABRIC.Domains.Domain | Where-Object Id -EQ $id
    
    $Item = $XMLData
    $Data = [ordered]@{
        id = $item.id
        Name = $item.Name
        DNSDomain = $item.DNSDomain
        DNSDomainExternal = $item.DNSDomainExternal
        DomainNetBios = $item.DomainNetBios
        DomainAdmin = $item.DomainAdmin
        DomainAdminPassword = $item.DomainAdminPassword
        DomainAdminDomain = $item.DomainAdminDomain
        DomainDS = $item.DomainDS
        BaseOU = $item.BaseOU
        MachienObjectOU = $item.MachienObjectOU
        SiteName = $item.SiteName
        OptionalData = $item.OptionalData
        Active = $item.Active
        }
    $Return = New-Object -TypeName psobject -Property $Data
    if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
}
Function Get-VIAXMLFabricDomainOU
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=2,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $ParentItem  = ($Settings.FABRIC.Domains.Domain | Where-Object Id -EQ $id)
    $Items  = ($Settings.FABRIC.Domains.Domain | Where-Object Id -EQ $id).DomainOUs.DomainOU
    foreach($Item in $Items){
        $Data = [ordered]@{
            Name = $item.Name;
            Path = $item.Path;
            ParentID = $ParentItem.Id;
            ParentName = $ParentItem.Name;
            Active = $item.Active;
            }
        $Return = New-Object -TypeName psobject -Property $Data
        if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
    }
}
Function Get-VIAXMLFabricDomainAccount
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=2,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $ParentItem  = ($Settings.FABRIC.Domains.Domain | Where-Object Id -EQ $id)
    $Items  = ($Settings.FABRIC.Domains.Domain | Where-Object Id -EQ $id).DomainAccounts.DomainAccount
    foreach($Item in $Items){
        $Data = [ordered]@{
            Name = $item.Name;
            AccountDescription = $item.AccountDescription;
            OUName = $item.OUName;
            AccountType = $item.AccountType;
            MemberOf = $item.MemberOf
            ParentID = $ParentItem.Id;
            ParentName = $ParentItem.Name;
            Active = $item.Active;
            }
        $Return = New-Object -TypeName psobject -Property $Data
        if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
    }
}
Function Get-VIAXMLFabricDomainGroup
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=2,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $ParentItem  = ($Settings.FABRIC.Domains.Domain | Where-Object Id -EQ $id)
    $Items  = ($Settings.FABRIC.Domains.Domain | Where-Object Id -EQ $id).DomainGroups.DomainGroup
    foreach($Item in $Items){
        $Data = [ordered]@{
            Name = $item.Name;
            Description = $item.Description;
            DomainOU = $item.DomainOU;
            GroupScope = $item.GroupScope;
            ParentID = $ParentItem.Id;
            ParentName = $ParentItem.Name;
            Active = $item.Active;
            }
        $Return = New-Object -TypeName psobject -Property $Data
        if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
    }
}
Function Get-VIAXMLFabricDomainCertificate
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=2,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $ParentItem  = ($Settings.FABRIC.Domains.Domain | Where-Object Id -EQ $id)
    $Items  = ($Settings.FABRIC.Domains.Domain | Where-Object Id -EQ $id).Certificates.Certificate
    foreach($Item in $Items){
        $Data = [ordered]@{
            Name = $item.Name;
            Description = $item.Description;
            Path = $item.Path;
            Destination = $item.Destination;
            PW = $item.PW;
            ParentID = $ParentItem.Id;
            ParentName = $ParentItem.Name;
            Active = $item.Active;
            }
        $Return = New-Object -TypeName psobject -Property $Data
        if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
    }
}
Function Get-VIAXMLFabricServer
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=2,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $Items  = ($Settings.FABRIC.Servers.Server | Where-Object Id -EQ $id)
    foreach($Item in $Items){
        $Data = [ordered]@{
            id = $Item.id
            Name = $Item.Name
            ComputerName = $Item.ComputerName
            Deploy = $Item.Deploy
            DeployOrder = $Item.DeployOrder
            WaitForDeployment = $Item.WaitForDeployment
            Virtual = $Item.Virtual
            Memory = $Item.Memory
            CPUCount = $Item.CPUCount
            DiffOrCreate = $Item.DiffOrCreate
            Type = $Item.Type
            Version = $Item.Version
            Edition = $Item.Edition
            UI = $Item.UI
            DomainJoined = $Item.DomainJoined
            MachineObjectOU = $Item.MachineObjectOU
            OOBName = $Item.OOBName
            OOBIPAddress = $Item.OOBIPAddress
            OOBSubnetMask = $Item.OOBSubnetMask
            OOBDefaultGateway = $Item.OOBDefaultGateway
            OOBVLANID = $Item.OOBVLANID
            Path = $item.Path
            Active = $item.Active
            }
        $Return = New-Object -TypeName psobject -Property $Data
        if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
    }
}
Function Get-VIAXMLFabricServerRole
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=2,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $ParentItem  = ($Settings.FABRIC.Servers.Server | Where-Object Id -EQ $id)
    $Items  = ($Settings.FABRIC.Servers.Server | Where-Object Id -EQ $id).Roles.Role
    foreach($Item in $Items){
        $Data = [ordered]@{
            Name = $item.Name;
            RoleUUID = $item.RoleUUID;
            ParentID = $ParentItem.Id;
            ParentName = $ParentItem.Name;
            Active = $item.Active;
            }
        $Return = New-Object -TypeName psobject -Property $Data
        if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
    }
}
Function Get-VIAXMLFabricServerOptionalSetting
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=2,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $ParentItem  = ($Settings.FABRIC.Servers.Server | Where-Object Id -EQ $id)
    $Items  = ($Settings.FABRIC.Servers.Server | Where-Object Id -EQ $id).OptionalSettings.OptionalSetting
    foreach($Item in $Items){
        $Data = [ordered]@{
            Name = $item.Name;
            Data = $item.Data;
            ParentID = $ParentItem.Id;
            ParentName = $ParentItem.Name;
            Active = $item.Active;
            }
        $Return = New-Object -TypeName psobject -Property $Data
        if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
    }
}
Function Get-VIAXMLFabricServerNetworkadapter
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=2,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $ParentItem  = ($Settings.FABRIC.Servers.Server | Where-Object Id -EQ $id)
    $Items  = ($Settings.FABRIC.Servers.Server | Where-Object Id -EQ $id).Networkadapters.Networkadapter
    foreach($Item in $Items){
        $Data = [ordered]@{
            Name = $item.Name;
            MACAddress = $item.MACAddress;
            IPAddress = $item.IPAddress;
            DefaultGateway = $item.DefaultGateway;
            PrefixLength = $item.PrefixLength;
            DNS = $item.DNS;
            ConnectedToNetwork = $item.ConnectedToNetwork;
            ParentID = $ParentItem.Id;
            ParentName = $ParentItem.Name;
            Active = $item.Active;
            }
        $Return = New-Object -TypeName psobject -Property $Data
        if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
    }
}
Function Get-VIAXMLFabricServerNetworkTeam
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=2,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $ParentItem  = ($Settings.FABRIC.Servers.Server | Where-Object Id -EQ $id)
    $Items  = ($Settings.FABRIC.Servers.Server | Where-Object Id -EQ $id).NetworkTeams.NetworkTeam
    foreach($Item in $Items){
        $Data = [ordered]@{
            Name = $item.Name;
            Member = $item.Member;
            ParentID = $ParentItem.Id;
            ParentName = $ParentItem.Name;
            Active = $item.Active;
            }
        $Return = New-Object -TypeName psobject -Property $Data
        if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
    }
}
Function Get-VIAXMLFabricServerDataDisk
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=2,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $ParentItem  = ($Settings.FABRIC.Servers.Server | Where-Object Id -EQ $id)
    $Items  = ($Settings.FABRIC.Servers.Server | Where-Object Id -EQ $id).DataDisks.DataDisk
    foreach($Item in $Items){
        $Data = [ordered]@{
            Name = $item.Name;
            DiskSize = $item.DiskSize;
            FileSystem = $item.FileSystem;
            ParentID = $ParentItem.Id;
            ParentName = $ParentItem.Name;
            Active = $item.Active;
            }
        $Return = New-Object -TypeName psobject -Property $Data
        if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
    }
}
Function Get-VIAXMLFabricVHD
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=2,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $ParentItem  = ($Settings.FABRIC | Where-Object Id -EQ $id)
    $Items  = ($Settings.FABRIC.VHDs.VHD | Where-Object Id -EQ $id)
    foreach($Item in $Items){
        $Data = [ordered]@{
            id = $item.id;
            Name = $item.Name;
            Type = $item.Type;
            Version = $item.Version;
            Edition = $item.Edition;
            UI = $item.UI;
            Location = $item.Location;
            License = $item.License;
            OptionalData = $item.OptionalData;
            ParentID = $ParentItem.Id;
            ParentName = $ParentItem.Name;
            Active = $item.Active;
            }
        $Return = New-Object -TypeName psobject -Property $Data
        if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
    }
}
Function Get-VIAXMLFabricRoles
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=2,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $ParentItem  = ($Settings.FABRIC | Where-Object Id -EQ $id)
    $Items  = ($Settings.FABRIC.Roles.Role | Where-Object Id -EQ $id)
    foreach($Item in $Items){
        $Data = [ordered]@{
            id = $item.id;
            Name = $item.Name;
            Description = $item.Description;
            Config = [array]$item.Config.SelectNodes("*");
            ParentID = $ParentItem.Id;
            ParentName = $ParentItem.Name;
            Active = $item.Active;
            }
        $Return = New-Object -TypeName psobject -Property $Data
        if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
    }
}
Function Get-VIAXMLFabricServices
{
    [cmdletbinding(SupportsShouldProcess=$True)]

    Param(
    [Parameter(Position=0,Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    $id,

    [Parameter(Position=1,Mandatory=$false)]
    $SettingsFile = $SettingsFile,

    [Parameter(Position=2,Mandatory=$false)]
    [switch]$Active
    )

    #Read data from XML
    [xml]$Settings = Get-Content $SettingsFile -ErrorAction Stop
    $ParentItem  = ($Settings.FABRIC | Where-Object Id -EQ $id)
    $Items  = ($Settings.FABRIC.Services.Service | Where-Object Id -EQ $id)
    foreach($Item in $Items){
        $Data = [ordered]@{
            id = $item.id;
            Name = $item.Name;
            Description = $item.Description;
            HA = $item.HA;
            Config = [array]$item.Config.SelectNodes("*");
            ParentID = $ParentItem.Id;
            ParentName = $ParentItem.Name;
            Active = $item.Active;
            }
        $Return = New-Object -TypeName psobject -Property $Data
        if($Active -eq $true){$Return | Where-Object -Property Active -EQ -Value True}else{$Return}
    }
}

