Function Add-VIARacAdmUser {
    Param (
        $RACRootUser,
        $RACRootUserPass,
        $IPAddress,
        $Index = "3",
        $UserToAdd,
        $PasswordToAdd
    )

    $RACADMExe = "C:\Program Files\Dell\SysMgt\rac5\racadm.exe"
    $PrivilegeToAdd ="0x000001ff"

    & $RACADMExe -r $IPAddress -u $RACRootUser -p $RACRootUserPass config -g cfgUserAdmin -o cfgUserAdminUserName -i $Index $UserToAdd
    & $RACADMExe -r $IPAddress -u $RACRootUser -p $RACRootUserPass config -g cfgUserAdmin -o cfgUserAdminPassword -i $Index $PasswordToAdd
    & $RACADMExe -r $IPAddress -u $RACRootUser -p $RACRootUserPass config -g cfgUserAdmin -i $Index -o cfgUserAdminPrivilege $PrivilegeToAdd
    & $RACADMExe -r $IPAddress -u $RACRootUser -p $RACRootUserPass config -g cfgUserAdmin -i $Index -o cfgUserAdminEnable 1
    & $RACADMExe -r $IPAddress -u $RACRootUser -p $RACRootUserPass config -g cfgUserAdmin -i $Index -o cfgUserAdminIpmiLanPrivilege 4
}
Function Remove-VIARacAdmUser {
    Param (
        $RACRootUser,
        $RACRootUserPass,
        $IPAddress,
        $Index = "3"
    )

    $RACADMExe = "C:\Program Files\Dell\SysMgt\rac5\racadm.exe"
    & $RACADMExe -r $IPAddress -u $RACRootUser -p $RACRootUserPass config -g cfgUserAdmin -o cfgUserAdminUserName -i $Index `"`" 2>&1
}
Function Enable-VIARacAdmIPMI {
    Param (
        $IPAddress,
        $RACRootUser,
        $RACRootUserPass
    )
    $RACADMExe = "C:\Program Files\Dell\SysMgt\rac5\racadm.exe"
    & $RACADMExe -r $IPAddress -u $RACRootUser -p $RACRootUserPass config -g cfgIpmiLan -o cfgIpmiLanEnable 1
}
Function Set-VIARacAdmPower {
    Param (
        $IPAddress,
        $RACRootUser,
        $RACRootUserPass,
        $Mode
    )
    $RACADMExe = "C:\Program Files\Dell\SysMgt\rac5\racadm.exe"
    switch ($Mode)
    {
        'Off' {
            & $RACADMExe -r $IPAddress -u $RACRootUser -p $RACRootUserPass serveraction powerdown
        }
        'On' {
            & $RACADMExe -r $IPAddress -u $RACRootUser -p $RACRootUserPass serveraction powerup
        }
        Default {}
    }
}
Function Set-VIARacAdmNextBoot {
    Param (
        $IPAddress,
        $RACRootUser,
        $RACRootUserPass,
        $Mode
    )
    $RACADMExe = "C:\Program Files\Dell\SysMgt\rac5\racadm.exe"
    switch ($Mode)
    {
        'PXE' {
            & $RACADMExe -r $IPAddress -u $RACRootUser -p $RACRootUserPass config -g cfgServerInfo -o cfgServerFirstBootDevice PXE
        }
        Default {}
    }
}
