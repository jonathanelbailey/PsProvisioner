$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Install-Dependencies" {
    It "installs a chocolatey package" {
        Push-Location 'testdrive:'
        New-DependencyRequirement -DisplayName 'testapp' -DisplayVersion '1.0' -Source 'choco'
        $result = Install-Dependencies -testmode
        $expected = $true
        $result | should be $expected
    }

    it 'installs a git package'{
        Set-Location 'testdrive:'
        New-DependencyRequirement -DisplayName 'gitapp' -DisplayVersion '1.0' -Source 'git'
        $result = Install-Dependencies -testmode
        $expected = $true
        $result | should be $expected
    }
    it 'installs a custom package'{
        Set-Location 'testdrive:'
        New-DependencyRequirement -DisplayName 'customapp' -DisplayVersion '1.0' -Source 'custom'
        $result = Install-Dependencies -testmode
        $expected = $true
        $result | should be $expected
    }
    it 'outputs a hash showing the install success'{

    }
    it 'outputs a hash showing the install failure'{

    }
    Pop-Location
}
