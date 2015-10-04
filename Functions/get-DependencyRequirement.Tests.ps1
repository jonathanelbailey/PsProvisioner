$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "get-DependencyRequirement" {
    It "outputs a serialized object" {
    if (((get-psdrive).Name -match 'z') -eq $false){
        new-psdrive -Name z -PSProvider FileSystem -Root 'testdrive:' -Description testdrive -Scope global
        set-location z:
    }
    New-DependencyRequirement -DisplayName 'testapp' -DisplayVersion '1.0' -Source 'choco'
    Initialize-ProvisionerTypes
    $result = Get-dependencyrequirement
    $obj = New-Object PsProvisioner.DependencyInformation
    $obj.DisplayName = 'testapp'
    $obj.DisplayVersion = '1.0'
    $obj.Source = 'choco'
    $expected = $obj
    $result | should be $expected
    }
    It "returns a value of false if an xml file doesn't exist" {
        $result = Get-dependencyrequirement
        $result | should be $false
    }
}
