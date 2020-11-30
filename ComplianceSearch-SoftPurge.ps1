
Import-Module ExchangeOnlineManagement


Connect-ExchangeOnline
import-module -Name c:\dev\git\nvpowershell\Common -Verbose -Force
$config = (Import-PowerShellDataFile "C:\dev\config\config.psd1")
$adminUpn = $config.AdminUpn

Connect-IPPSSession -UserPrincipalName $adminUpn
#   https://protection.office.com/contentsearchbeta?ContentOnly=1
#   Get-ComplianceSearch
<#
    $complianceSearch = "[ALERT]:richlandglass.com"
    $matchquery = 'from:richlandglass.com'
    $searchDescription = ""Phishing campaing targing staff from paul.parent@richlandglass.com"
#>        
        

$complianceSearch = "[ALERT]:Gmail phish"
#               dateformat is MM/dd/yyyy
$matchquery = 'sent>=11/17/2020 AND (From:"username@gmail.com" OR From:"first.last@gmail.com" OR From:"gmail.com")'
$searchDescription = ("This is a description " + " ---- " + $matchquery)

New-ComplianceSearch -ExchangeLocation All -AllowNotFoundExchangeLocationsEnabled $true `
        -Name $complianceSearch `
        -ContentMatchQuery $matchquery `
        -Description $searchDescription


Start-ComplianceSearch $complianceSearch

#LOOP UNTIL STATUS CHANGES TO COMPLETED
Do
{
    Write-Host ((get-timestamp) + "Waiting until $complianceSearch is finished running...")
    $Status = Get-ComplianceSearch $complianceSearch | Select-Object -ExpandProperty Status
    Start-Sleep -Seconds 5
}
Until ($Status -eq "Completed")
#GET THE FINAL RESULTS
Get-ComplianceSearch $complianceSearch | Select-Object Name, RunBy, JobEndTime, Status, Items


#ACTION THE SEARCH aka DELETE
#    SoftDelete: Purged items are recoverable by users until the deleted item retention period expires.
#    HardDelete: Purged items are marked for permanent removal from the mailbox and will be permanently removed the next time the mailbox is processed by the Managed Folder Assistant.
#New-ComplianceSearchAction -SearchName $complianceSearch -Purge -PurgeType SoftDelete