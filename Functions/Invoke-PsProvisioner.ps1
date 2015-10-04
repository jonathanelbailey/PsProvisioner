function Invoke-PsProvisioner {
    [CmdletBinding(DefaultParameterSetName='GetPrograms')]
    Param ( [Parameter( Position=0,
                        Mandatory=$true,
                        ParameterSetname='GetPrograms' )]
            [switch]$GetPrograms,
            [Parameter( Position=1,
                        Mandatory=$false,
                        ParameterSetName='GetPrograms' )]
            [switch]$ShowVersion,
            [Parameter( Position=0,
                        Mandatory=$true,
                        ParameterSetName='ProvisionPrograms' )]
            [string]$ProvisionPrograms,
            [Parameter( Position=1,
                        Mandatory=$false,
                        ParameterSetName='Provisionprograms' )]
            [switch]$provisionProgramsVersion,
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
            [Parameter( Position=4,
                        Mandatory=$true,
                        ParameterSetName='CreateManifest' )]
            [switch]$CreateManifest,
            [Parameter( Position=0,
                       Mandatory=$false,
                       ParameterSetName='CreateManifest' )]
            [string]$Path,
            [Parameter( Position=0,
                        Mandatory=$true,
                        ParameterSetName='ApplyProvisions' )]
            [switch]$ApplyProvisions )
    BEGIN{}
    PROCESS{
        switch($PSCmdlet.ParameterSetName){
            'GetPrograms' { if ( $ShowVersion -eq $false ){ $Output = Get-InstalledProgramsInfo | Select-Object -Property DisplayName }
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
            'ProvisionPrograms' { $xmlPath = Join-Path (Get-Location).Path -ChildPath PsProvisioner\Provisions.xml
                                if ((Test-Path $xmlPath) -eq $false ){
                                    Export-ProvisionFile
                                }
                                Get-DependencyRequirement }
            'ApplyProvisions' { Install-Dependencies }
        }
    }
    END{}
}
