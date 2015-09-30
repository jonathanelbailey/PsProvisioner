$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Export-ProvisionFile" {
    It "creates an xml file called Provisions.xml" {
        $true | Should Be $false
    }
}
