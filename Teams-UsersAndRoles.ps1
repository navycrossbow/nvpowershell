#   https://dailysysadmin.com/KB/Article/3607/microsoft-teams-powershell-commands-to-list-all-members-and-owners/

Import-Module MicrosoftTeams


$config = (Import-PowerShellDataFile "C:\dev\config.psd1")
$tenantId = $config.TenantId

Connect-MicrosoftTeams  -TenantId $tenantId


$AllTeams = Get-Team
$TeamList = @()

Foreach ($Team in $AllTeams)
{       
        $TeamGUID = $Team.GroupId.ToString()
        $TeamName = $Team.DisplayName 
        write-host $TeamName
        $TeamUsers = Get-TeamUser -GroupId $TeamGUID
        $TeamOwner = ($TeamUsers | Where-Object {$_.Role -eq 'Owner'}).User
        $TeamMember = ($TeamUsers | Where-Object {$_.Role -eq 'member'}).User
        $TeamList = $TeamList + [PSCustomObject]@{
            TeamName = $TeamName; 
            TeamObjectID = $TeamGUID; 
            TeamOwners = $TeamOwner -join '; '; 
            TeamMembers = $TeamMember -join ";";
        }
}
$TeamList | export-csv c:\temp\TeamsData.csv -NoTypeInformation 





foreach ($team in $TeamList | Where-Object {$_.TeamMembers.length -gt 0}){

    $to = $team.TeamOwners
    $subject = "Team membership: " + $team.TeamName
    $members = $team.TeamMembers.replace(";", "`n")
    $body = @"
Hello

Can you please confirm that all these users still require access to the teams site that you are currently an owner of.

$members

Awesome, great, thanks...

"@
    write-host "---------------------------------------"
    write-host "TO:         $to"
    write-host "SUBJECT:    $subject"
    write-host "BODY:       $body"    




}