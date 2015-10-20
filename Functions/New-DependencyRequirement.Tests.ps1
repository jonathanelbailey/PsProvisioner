$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "New-DependencyRequirement" {
    if (((get-psdrive).Name -match 'z') -eq $false){
        new-psdrive -Name z -PSProvider FileSystem -Root 'testdrive:' -Description testdrive -Scope global
        Push-Location z:
    }
    It "creates an xml file." {
        if ((Test-Path psprovisioner) -eq $true){
            Remove-Item psprovisioner -Recurse -Force
        }
        $path = (get-location).Path
        $dir = Join-Path $path -ChildPath PsProvisioner
        $xmlpath = Join-Path $dir -ChildPath Provisions.xml
        new-item $dir -ItemType directory
        new-dependencyrequirement -DisplayName testapp -DisplayVersion 1.0 -Source choco
        $result = Test-Path $xmlpath
        $expected = $true
        $result | should be $expected
    }
    it 'can produce a serializable xml document'{
        if ((test-path (Get-Location).Path) -ne 'z:'){
            Set-Location z:
        }
        if ((Test-Path psprovisioner) -eq $true){
            Remove-Item psprovisioner -Recurse -Force
        }
        $path = (get-location).Path
        $dir = Join-Path $path -ChildPath PsProvisioner
        $xmlpath = Join-Path $dir -ChildPath Provisions.xml
        new-item $dir -ItemType directory
        New-DependencyRequirement -DisplayName 'testapp' -DisplayVersion '1.0' -Source 'choco'
        $test = Import-Clixml $xmlpath
        $obj = New-Object  -TypeName PsProvisioner.DependencyInformation
        $obj.DisplayName = 'testapp'
        $obj.Source = 'choco'
        $obj.DisplayVersion = '1.0'
        $obj.ArgumentList = ''
        $test[0].displayname | should be $obj.DisplayName
        $test[0].source | should be $obj.Source
        $test[0].displayversion | should be $obj.DisplayVersion
        $test[0].argumentlist | should be $obj.ArgumentList
    }
    Pop-Location
}
