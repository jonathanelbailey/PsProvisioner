$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Export-ProvisionFile" {
        if (((get-psdrive).Name -match 'z') -eq $false){
            new-psdrive -Name z -PSProvider FileSystem -Root 'testdrive:' -Description testdrive -Scope global
            set-location z:
        }
    It "creates an xml file called Provisions.xml" {
        if ((Test-Path psprovisioner) -eq $true){
            Remove-Item psprovisioner -Recurse -Force
        }
        $path = (get-location).Path
        $dir = Join-Path $path -ChildPath PsProvisioner
        $ymlpath = Join-Path $dir -ChildPath Provisions.yml
        $xmlpath = Join-Path $dir -ChildPath Provisions.xml
        $source = @'
Provisions:
  1:
    Name: testapp
    Source: choco
    Version: 1.0
    Args:  
'@
        new-item $dir -ItemType directory
        Set-Content -path $ymlpath -Value $source -Encoding UTF8
        Export-ProvisionFile
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
        $ymlpath = Join-Path $dir -ChildPath Provisions.yml
        $xmlpath = Join-Path $dir -ChildPath Provisions.xml
        $source = @'
Provisions:
  1:
    Name: testapp
    Source: choco
    Version: 1.0
    Args:
'@
        new-item $dir -ItemType directory
        Set-Content -Path $ymlpath -Value $source -Encoding UTF8
        Export-ProvisionFile
        $test = Import-Clixml $xmlpath
        $result = $test[0].gettype().name
        $obj = New-Object  -TypeName PsProvisioner.DependencyInformation
        $obj.DisplayName = 'testapp'
        $obj.Source = 'choco'
        $obj.DisplayVersion = '1.0'
        $obj.ArgumentList = ''
        $expected = $obj.GetType()
        $result | should be $expected
    }
    set-location c:
}
