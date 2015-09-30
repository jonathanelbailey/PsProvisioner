$DebugPreference = 'silentlycontinue'

function Get-InstalledProgramsInfo {
    BEGIN{
        Initialize-ProvisionerTypes | Out-Null
        $Installedx64Programs = Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | `
                                 Select-Object DisplayName,DisplayVersion,Publisher,InstallDate,UrlInfoAbout
        $Installedx86Programs = Get-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | `
                                    Select-Object DisplayName,DisplayVersion,Publisher,InstallDate,UrlInfoAbout
        $DependencyNames = $Dependencies.DisplayName
        $InstalledPrograms = @()
        $Installed = @()
    }
    PROCESS{
        $x = 0
        foreach ($p in $Installedx64Programs){
            $InstalledPrograms += $p
            $x++
        }
        $y=0
        foreach ($p in $Installedx86Programs){
            $InstalledPrograms += $p
            $y++
        }
        $z = 0
        foreach ($p in $InstalledPrograms){
            
            Write-Debug " Program is $($p.displayname), InstallDate is $($p.installdate)"
            
            $Obj = New-Object -TypeName PsProvisioner.InstalledProgramInformation
            $Obj.DisplayName = $p.DisplayName
            $Obj.DisplayVersion = $p.DisplayVersion
            $Obj.InstalledDate = $p.InstallDate
            $Obj.isInstalled = $true
            $Obj.Publisher = $p.Publisher
            $Obj.Source = $p.UrlInfoAbout
            $Installed += $Obj
            $z++
        }
    }
    END{
        Write-Output $Installed
        $Source = @"
Total Number of 64-Bit Applications Installed: $x
Total Number of 32-Bit Applications Installed: $y
Total Number of Applications Installed: $z
Total Applications Listed: $($Installed.count)
"@
        Write-host -ForegroundColor Green $Source
    }
}
