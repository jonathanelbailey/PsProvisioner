function Export-ProvisionFile {
    BEGIN{
        Initialize-ProvisionerTypes
        $ProvisionPath = Join-Path (Get-Location).Path -ChildPath PsProvisioner\Provisions.yml
        $ProvisionYaml = Get-Yaml -FromFile $ProvisionPath
        $ProvisionObjects = @()
    }
    PROCESS{
        $ObjectCount = $ProvisionYaml.provisions.count
        $i = 1
        do {
                $value = $ProvisionYaml.values.$i
                $obj = New-Object -TypeName PsProvisioner.DependencyInformation
                $obj.DisplayName = $value.name
                $obj.DisplayVersion = $value.version
                $obj.Source = $value.source
                $obj.argumentlist = $value.args
                $ProvisionObjects += $obj
                $i++
        }
        until ($i -gt $ObjectCount)
    }
    END{
        $xmlPath = Join-Path (Get-Location).Path -ChildPath PsProvisioner\Provisions.xml
        Export-Clixml $xmlPath -InputObject $ProvisionObjects
        Write-Host -ForegroundColor Green "Total number of objects to create: $ObjectCount"
        Write-Host -ForegroundColor Green "Total number of objects created: $($ProvisionObjects.count)"
    }
}
