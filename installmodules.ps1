#   https://office365itpros.com/2020/06/22/maintaining-office-365-powershell-modules/
# UpdateOffice365PowerShellModules.PS1
# Mentioned in Chapter 4 of Office 365 for IT Pros
# https://github.com/12Knocksinna/Office365itpros/blob/master/UpdateOffice365PowerShellModules.PS1
# Very simple script to check for updates to a defined set of PowerShell modules used to manage Office 365 services
# If an update for a module is found, it is downloaded and applied.
# Once all modules are checked for updates, we remove older versions that might be present on the workstation
# Define the set of modules installed and updated from the PowerShell Gallery that we want to maintain
$Modules = @(
    "MicrosoftTeams", 
    "MSOnline", 
    "AzureAD",                                  #   https://docs.microsoft.com/en-us/microsoft-365/enterprise/connect-to-microsoft-365-powershell?view=o365-worldwide 
    "ExchangeOnlineManagement", 
    "Microsoft.Online.Sharepoint.PowerShell",   #   https://www.powershellgallery.com/packages/Microsoft.Online.SharePoint.PowerShell/16.0.20518.12000 
    "ORCA",
    "CredentialManager"                         #   https://www.powershellgallery.com/packages/CredentialManager/2.0
)

# Check and update all modules to make sure that we're at the latest version
ForEach ($Module in $Modules) 
{
   Write-Host "Installing" $Module
   Install-Module $Module -Force -ErrorAction SilentlyContinue
}

