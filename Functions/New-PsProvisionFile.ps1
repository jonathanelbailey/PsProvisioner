function New-PsProvisionFile {
    BEGIN{
        $Path = (Get-Location).Path
        New-Item -Path .\PsProvisioner -ItemType directory
        $FilePath = Join-Path $Path -ChildPath PsProvisioner\Provisions.yml
    }
    PROCESS{
        $Source = @'
# PsProvisioner

# Valid Input:

# Name $DisplayName; <-- Must Match the Name of the application.  Use 'Invoke-PsProvisioner -ListAll' to search reference machine for the App.
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
#     Name: poweryaml
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
  2:
    Name: 
    Source: 
    Version:
    Args:
  3:
    Name: 
    Source: 
    Version:
    Args:
'@
    }
    END{
        Add-Content -Path $FilePath -Value $Source
    }
}
