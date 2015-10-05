$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Invoke-PsProvisioner" {
    It "calls New-PsProvisionFile" {
        $result = Invoke-PsProvisioner -CreateManifest -testmode
        $expected = 'CreateManifest Successful'
        $result | should be $expected

    }
    It "calls new-dependencyrequirement " {
        $result = Invoke-PsProvisioner -NewDependency -DisplayName 'testapp' -DisplayVersion '1.0' -Source 'choco' -testmode
        $expected = 'NewDependency Successful'
        $result | should be $expected
    }
    It "calls get-dependencyrequirement" {
        $result = Invoke-PsProvisioner -ProvisionPrograms -testmode
        $expected = 'provisionPrograms Successful'
        $result | should be $expected
    }
    It "calls install-dependencies" {
        $result = Invoke-PsProvisioner -ApplyProvisions -testmode
        $expected = 'ApplyProvisions Successful'
        $result | should be $expected
    }
}
