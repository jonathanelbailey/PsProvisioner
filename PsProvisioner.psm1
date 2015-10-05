Resolve-Path $PSScriptRoot\*.ps1 |
? { -not ($_.ProviderPath.Contains(".Tests.")) } |
% { . $_.ProviderPath }

Export-ModuleMember -Function Invoke-PsProvisioner