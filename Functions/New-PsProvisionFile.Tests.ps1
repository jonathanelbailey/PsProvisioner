$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "New-PsProvisionFile" {
    It "creates a folder called PsProvisioner" {
        Push-Location 'testdrive:'
        if ((Test-Path psprovisioner) -eq $true){
            Remove-Item psprovisioner -Recurse -Force
        }
        New-PsProvisionFile
        $folder = gci -Directory | Where-Object name -eq 'PsProvisioner' | select -Property Attributes
        $result = $folder.attributes -eq 'Directory'
        $expected = $true
        $result | should be $expected
    }
    it 'creates a yaml file inside the folder called provisions.yml'{
        Push-Location 'testdrive:'
        if ((Test-Path psprovisioner) -eq $true){
            Remove-Item psprovisioner -Recurse -Force
        }
        New-PsProvisionFile
        $file = gci 'PsProvisioner'
        $result = $file.Name
        $expected = 'Provisions.yml'
        $result | should be $expected
    }
    Pop-Location
}
