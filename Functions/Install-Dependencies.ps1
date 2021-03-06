﻿function Install-Dependencies {
    Param( [switch]$TestMode )
    BEGIN{
        $Dependency =  Get-DependencyRequirement
        $result = @{}
    }
    PROCESS{
        foreach ($d in $Dependency){
            if ($TestMode -eq $true){
                switch($d.source){
                    git { $true }
                    choco { $true }
                    custom { $true }
                }
                $result.Add($($d.displayname), $true)
            }
            elseif($testmode -eq $false){
                switch ($d.source){
                    git { git clone $d.argumentlist --depth=1 }
                    choco { choco install $d.displayname $d.argumentlist -y }
                    custom { $d.argumentlist }
                }
                if ($LASTEXItCODE -eq '0' -or '3010'){
                    $result.Add($($d.displayname), $true)
                }
                else{
                    $result.Add($($d.displayname), $false)
                }
            }
        }
    }
    END{        
        Write-Output $Result
    }
}
