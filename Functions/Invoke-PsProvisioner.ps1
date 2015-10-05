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
            [switch]$ProvisionPrograms,
            [Parameter( Position=1,
                        Mandatory=$false,
                        ParameterSetName='Provisionprograms' )]
            [switch]$provisionProgramsVersion,
            [Parameter( Position=0,
                        Mandatory=$false,
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
                        Mandatory=$false,
                        ParameterSetName='NewDependency' )]
            [string]$ArgumentList,
            [Parameter( Position=0,
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
            [switch]$ApplyProvisions,
            [Parameter( Mandatory=$false )]
            [switch]$testmode )
    BEGIN{}
    PROCESS{
        switch($PSCmdlet.ParameterSetName){
            'GetPrograms' { if ($testmode -eq $true){
                                Write-Output 'GetPrograms Successful'
                            }
                            elseif($testmode -eq $false){
                                if ( $ShowVersion -eq $false ){ $Output = Get-InstalledProgramsInfo | Select-Object -Property DisplayName }
                                else{ $Output = Get-InstalledProgramsInfo | Select-Object -Property DisplayName,DisplayVersion }
                                Write-Output $Output
                            }
                          }
            'CreateManifest' { if ($testmode -eq $true){
                                Write-Output 'CreateManifest Successful'
                             }
                             elseif($testmode -eq $false){
                                 if ((Test-Path $Path) -eq $true){
                                    Set-Location $Path
                                    New-PsProvisionFile
                                 }
                                 else{
                                    New-PsProvisionFile
                                 }
                             }
                           }
            'NewDependency' { if ($testmode -eq $true){
                                Write-Output 'NewDependency Successful'
                              }
                              elseif($testmode -eq $false){
                                  New-DependencyRequirement -DisplayName $DisplayName -DisplayVersion $DisplayVersion -Source $Source -argumentlist $ArgumentList
                              }
                            }
            'ProvisionPrograms' { if ($testmode -eq $true){
                                      Write-Output 'provisionPrograms Successful'
                                  }
                                  elseif($testmode -eq $false){
                                      $xmlPath = Join-Path (Get-Location).Path -ChildPath PsProvisioner\Provisions.xml
                                      if ((Test-Path $xmlPath) -eq $false ){
                                          Export-ProvisionFile
                                      }
                                      Get-DependencyRequirement
                                  }
                                }
            'ApplyProvisions' { if ($testmode -eq $true){
                                    Write-Output 'ApplyProvisions Successful'
                                }
                                elseif($testmode -eq $false){
                                    Install-Dependencies
                                }
                              }
        }
    }
    END{}
}
