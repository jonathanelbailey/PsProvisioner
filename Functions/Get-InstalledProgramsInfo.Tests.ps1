$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

.\Initialize-ProvisionerTypes.ps1
Initialize-ProvisionerTypes

Describe "Get-InstalledProgramsInfo" {
    It "returns an array of objects" {
        $test = Get-InstalledProgramsInfo
        $type = $test.GetType()
        $actual = $type.BaseType.Name
        $expected = 'array'
        $actual | should be $expected
    }
    it 'returns an InstalledProgramInformation type'{
        $test = Get-InstalledProgramsInfo
        $sample = $test[(Get-Random -Maximum $test.count)]
        $actual = $sample.gettype()
        $expected = 'PsProvisioner.InstalledProgramInformation'
        $actual | should be $expected
    }
}
