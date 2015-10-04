function New-DependencyRequirement {
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
        $NewDependency = New-Object PsProvisioner.DependencyInformation
        $NewDependency.DisplayName = $DisplayName
        $NewDependency.DisplayVersion = $DisplayVersion
        $NewDependency.Source = $Source
        $NewDependency.argumentlist = $argumentlist
        $DependencyArray += $NewDependency
    }
    END{
        Export-Clixml -Path $XmlPath -InputObject $DependencyArray
    }
}
