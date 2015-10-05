function get-DependencyRequirement {
    BEGIN{
        $XmlPath = Join-Path (get-location).Path -ChildPath 'PsProvisioner\Provisions.xml'
        if ((Test-Path $XmlPath) -eq $true){
            $Dependencyinfo = Import-Clixml -Path $XmlPath
        }
        else {
            Write-Host -ForegroundColor Yellow "$XmlPath Does not exist."
            Write-Output $false
        }
    }
    PROCESS{}
    END{
        Write-Output $Dependencyinfo
    }
}
