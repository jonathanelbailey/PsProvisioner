$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "get-DependencyRequirement" {
    It "outputs a serialized object" {
    Push-Location 'testdrive:'
    New-DependencyRequirement -DisplayName 'testapp' -DisplayVersion '1.0' -Source 'choco'
    $result = Get-dependencyrequirement
    $obj = New-Object PsProvisioner.DependencyInformation
    $obj.DisplayName = 'testapp'
    $obj.DisplayVersion = '1.0'
    $obj.Source = 'choco'
    $expected = $obj
    Remove-Item psprovisioner -Recurse -Force
    $result.displayname | should be $obj.DisplayName
    $result.displayversion | should be $obj.DisplayVersion
    $result.source | should be $obj.Source
    }
    It "returns a value of false if an xml file doesn't exist" {
        Push-Location 'testdrive:'
        if ((Test-Path psprovisioner) -eq $true){
            Remove-Item psprovisioner -Recurse -Force
        }
        $result = get-dependencyrequirement
        $result[0] | should be $false
    }
    Pop-Location
}
