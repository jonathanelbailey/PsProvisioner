function Initialize-ProvisionerTypes {
    BEGIN{
        $Source = @"
using System;

namespace PsProvisioner
{
    public class InstalledProgramInformation
    {
        public string DisplayName { get; set; }
        public string Source { get; set; }
        public string DisplayVersion { get; set; }
        public string Publisher { get; set; }
        public bool isInstalled { get; set; }
        private DateTime m_InstalledDate;

        public string InstalledDate
        {
            get
            {
                return m_InstalledDate.ToString();
            }
            set
            {
                string dateInput = value;
                if (dateInput.Length > 8)
                {
                    DateTime date = DateTime.Parse(dateInput);
                    m_InstalledDate = date;
                }
                if (dateInput.Length == 8) 
                {
                    Int32 year = Int32.Parse(dateInput.Substring(0, 4));
                    Int32 month = Int32.Parse(dateInput.Substring(4, 2));
                    Int32 day = Int32.Parse(dateInput.Substring(6, 2));
                    DateTime date = new DateTime(year, month, day);
                    m_InstalledDate = date;
                }
                else
                {
                    m_InstalledDate = DateTime.Now; // needs work.  This only removes error messages during instantiation.
                }
            }
        }
    }
    public class DependencyInformation
    {
        public string DisplayName { get; set; }
        public string DisplayVersion { get; set; }
        public string Source { get; set; }
        public string ArgumentList { get; set; }
        
    }
}
"@
    }
    PROCESS{
        add-type -Language CSharp -TypeDefinition $Source
        write-host -ForegroundColor Yellow 'PsProvisioner.InstalledProgramInformation has been initialized.'
        Write-Host -ForegroundColor Yellow 'PsProvisioner.DependencyInformation has been initialized.'
    }
    END{
        $checkIsInitialized = [PsProvisioner.InstalledProgramInformation],[PsProvisioner.DependencyInformation]
        foreach ($c in $checkIsInitialized.isclass){
            $passfail = $true
            if ($c.isclass -eq $true){
                if ($passfail -eq $false){
                    $passfail = $false
                }
                elseif($passfail -eq $true){
                    $passfail = $true
                }
            }
        }
        Write-Output $passfail
    }
}
