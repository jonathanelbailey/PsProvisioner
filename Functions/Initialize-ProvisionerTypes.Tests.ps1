$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Initialize-ProvisionerTypes" {
    It "Returns a value of true if both types load successfully" {
        $actual = initialize-provisionertypes
        $expected = $true
        $actual | should be $expected
    }
}
