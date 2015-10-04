$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Install-Dependencies" {
    It "installs a chocolatey package" {
        $true | Should Be $false
    }

    it 'installs a git package'{
    
    }
    it 'installs a custom package'{
    
    }
}
