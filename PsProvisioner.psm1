function Initialize-ProvisionerTypes{
    BEGIN{
        $isProgramTypeInitialized = [PsProvisioner.InstalledProgramInformation],[PsProvisioner.DependencyInformation] | Out-Null
        $Source = @"
using System;

namespace PsProvisioner
{
    public class InstalledProgramInformation
    {
        public string DisplayName { get; set; }
        public string Source { get; set; }
        public string DisplayVersion { get; set; }
        public string Publisher { get; set; }
        public bool isInstalled { get; set; }
        private DateTime m_InstalledDate;

        public string InstalledDate
        {
            get
            {
                return m_InstalledDate.ToString();
            }
            set
            {
                string dateInput = value;
                if (dateInput.Length > 8)
                {
                    DateTime date = DateTime.Parse(dateInput);
                    m_InstalledDate = date;
                }
                else 
                {
                    Int32 year = Int32.Parse(dateInput.Substring(0, 4));
                    Int32 month = Int32.Parse(dateInput.Substring(4, 2));
                    Int32 day = Int32.Parse(dateInput.Substring(6, 2));
                    DateTime date = new DateTime(year, month, day);
                    m_InstalledDate = date;
                }
            }
        }
    }
    public class DependencyInformation
    {
        public string DisplayName { get; set; }
        public string DisplayVersion { get; set; }
        public string Source { get; set; }
        public string ArgumentList { get; set; }
        
    }
}
"@
    }
    PROCESS{
        if($isProgramTypeInitialized.IsClass -eq $null){
            add-type -Language CSharp -TypeDefinition $Source
            write-host 'PsProvisioner.InstalledProgramInformation has been initialized.'
            Write-Host 'PsProvisioner.DependencyInformation has been initialized.'
        }
        else{
            Write-Host 'PsProvisioner.InstalledProgramInformation is already loaded.'
            Write-Host 'PsProvisioner.DependencyInformation is already loaded.'
        }
    }
    END{
        $checkIsInitialized = [PsProvisioner.InstalledProgramInformation],[PsProvisioner.DependencyInformation]
        Write-Output $checkIsInitialized
    }
}

Function Get-InstalledProgramsInfo{
    BEGIN{
        Initialize-ProvisionerTypes
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
"@
        Write-Output $Source
    }
}

Function Invoke-PsProvisioner{
    [CmdletBinding(DefaultParameterSetName='GetList')]
    Param ( [Parameter( Position=0,
                        Mandatory=$true,
                        ParameterSetname='GetList' )]
            [switch]$ListAll,
            [Parameter( Position=1,
                        Mandatory=$false,
                        ParameterSetName='GetList' )]
            [switch]$ShowVersion,
            [Parameter( Position=0,
                        Mandatory=$true,
                        ParameterSetName='ProvisionConfig' )]
            [string]$DesiredProgramDisplayName,
            [Parameter( Position=1,
                        Mandatory=$false,
                        ParameterSetName='ProvisionConfig' )]
            [switch]$DesiredProgramDisplayVersion,
            [Parameter( Position=0,
                        Mandatory=$true,
                        ParameterSetName='NewDependency' )]
            [switch]$NewDependency,
            [Parameter( Position=0,
                        Mandatory=$true,
                        ParameterSetName='NewDependency' )]
            [string]$DisplayName,
            [Parameter( Position=1,
                        Mandatory=$true,
                        ParameterSetName='NewDependency' )]
            [string]$DisplayVersion,
            [Parameter( Position=2,
                        Mandatory=$true,
                        ParameterSetName='NewDependency' )]
            [string]$Source,
            [Parameter( Position=3,
                        Mandatory=$true,
                        ParameterSetName='NewDependency' )]
            [string]$ArgumentList,
            [Parameter( Position=0,
                        Mandatory=$true,
                        ParameterSetName='CreateConfig' )]
            [switch]$CreateConfigurationFile,
            [Paramter( Position=1,
                       Mandatory=$false,
                       ParameterSetName='CreateConfig' )]
            [string]$Path,
            [Parameter( Position=0,
                        Mandatory=$true,
                        ParameterSetName='ApplyConfiguration' )]
            [switch]$ApplyConfiguration )
    BEGIN{}
    PROCESS{
        switch($PSCmdlet.ParameterSetName){
            'GetList' { if ( $ShowVersion -eq $false ){ $Output = Get-InstalledProgramsInfo | Select-Object -Property DisplayName }
                        else{ $Output = Get-InstalledProgramsInfo | Select-Object -Property DisplayName,DisplayVersion }
                        Write-Output $Output }
            'CreateConfig' { if ((Test-Path $Path) -eq $true){
                                Set-Location $Path
                                New-PsProvisionFile
                             }
                             else{
                                New-PsProvisionFile
                             } 
                           }
            'NewDependency' { New-DependencyRequirement -DisplayName $DisplayName -DisplayVersion $DisplayVersion -Source $Source -argumentlist $ArgumentList }
            'ProvisionConfig' { $xmlPath = Join-Path (Get-Location).Path -ChildPath PsProvisioner\Provisions.xml
                                if ((Test-Path $xmlPath) -eq $false ){
                                    Export-ProvisionFile
                                }
                                Get-DependencyRequirement }
            'ApplyConfiguration' { Install-Dependencies }
        }
    }
    END{}
}

function New-PsProvisionFile{
    BEGIN{
        $Path = (Get-Location).Path
        New-Item -Path .\PsProvisioner -ItemType directory
        $FilePath = Join-Path $Path -ChildPath PsProvisioner\Provisions.yml
    }
    PROCESS{
        $Source = @'
# PsProvisioner

# Valid Input:

# Name $DisplayName; <-- Must Match the Display Name of the application.  Use 'Invoke-PsProvisioner -ListAll' to search reference machine for the App.
# Source $Source; <-- Currently supports the following: 'choco','git','custom'
# Version $DisplayVersion; <-- Must Match the Display Version of the application. Use 'Invoke-PsProvisioner -ListAll -ShowVersion' to search reference machine for the App Version.
# Args $ArgumentList; <-- Use this for local installation of packages that are not available through Chocolatey.

# Example:

# Provisions:
#   1:
#     Name: Chocolatey
#     Source: Custom
#     Version:
#     Args: powershell.exe -executionpolicy bypass -noexit -command {iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))}  
#   2:
#     Name: Git
#     Source: choco
#     Version:
#     Args:
#   3:
#     Name: poshgit
#     Source: choco
#     Version:
#     Args:
#   4:
#     Name: poshyaml
#     source: git
#     version:
#     args: https://github.com/scottmuc/PowerYaml.git
#   5:
#     name: PsProvisioner
#     Source: git
#     Version: 0.1.0
#     args: https://github.com/jonathanelbailey/poshgit.git

Provisions:
  1:
    Name: 
    Source: 
    Version:
    Args:

'@
    }
    END{
        Add-Content -Path $FilePath -Value $Source
        Set-Location PsProvisioner
    }
}

Function Export-ProvisionFile{
    BEGIN{
        $ProvisionPath = Join-Path (Get-Location).Path -ChildPath PsProvisioner\Provisions.yml
        $ProvisionYaml = Get-Yaml -Path $ProvisionPath
        $ProvisionObjects = @()
    }
    PROCESS{
        $ObjectCount = $ProvisionYaml.provisions.count
        $i = 1
        do {
            foreach ($p in $ProvisionYaml.provisions){
                $obj = New-Object -TypeName PsProvisioner.DependencyInformation
                $obj.DisplayName = $p.name
                $obj.DisplayVersion = $p.version
                $obj.Source = $p.source
                $obj.argumentlist = $p.args
                $ProvisionObjects += $obj
                $i++
            }
        }
        until ($i -eq 5)
    }
    END{
        $xmlPath = Join-Path (Get-Location).Path -ChildPath PsProvisioner\Provisions.xml
        Export-Clixml $xmlPath -InputObject $ProvisionObjects
    }
}

Function New-DependencyRequirement{
    Param( $DisplayName,
           $DisplayVersion,
           $Source,
           $argumentlist )
    BEGIN{
        $XmlPath = join-path (Get-Location).Path -ChildPath PsProvisioner\Provisions.xml
        $DependencyArray = @()
        if ((test-path $XmlPath) -eq $false){
            Initialize-ProvisionerTypes
        }
        else {
           $DependencyArray += Import-Clixml -Path $XmlPath
        }
    }
    PROCESS{
        $NewDependency = New-Object PsProvisioner.DeploymentInformation
        $NewDependency.DisplayName = $DisplayName
        $NewDependency.DisplayVersion = $DisplayVersion
        $NewDependency.Source = $DeploymentInfo
        $NewDependency.argumentlist = $argumentlist
        $DependencyArray += $NewDependency
    }
    END{
        Export-Clixml -Path $XmlPath -InputObject $DependencyArray
    }
}

Function Get-DependencyRequirement {
    BEGIN{
        $XmlPath = Join-Path (get-location).Path -ChildPath 'PsProvisioner\Provisions.xml'
        if ((Test-Path $XmlPath) -eq $true){
            $Dependencyinfo = Import-Clixml -Path $XmlPath -IncludeTotalCount
        }
        else {
            Write-Host -ForegroundColor Yellow "$XmlPath Does not exist."
        }
    }
    PROCESS{}
    END{
        Write-Output $Dependencyinfo
    }
}

Function Install-Dependencies{
    BEGIN{
       $Dependency =  Get-DependencyRequirement
       $isInstalled = Get-InstalledProgramsInfo
    }
    PROCESS{
        foreach ($d in $Dependency){
            if ($isInstalled.DisplayName -match $d.displayname -and $isInstalled.isInstalled -eq $false){
                switch ($d){
                    git { git clone $d.DeploymentInfo --depth=1 }
                    choco { choco install $d.DeploymentInfo -y }
                    custom { $ScriptBlock }
                }
            }
            else { Write-Host "$d.DisplayName is already installed." }
        }
    }
    END{
        $Result = Get-InstalledProgramsInfo
        Write-Output $Result
    }
}