
Import-Module ExchangeOnlineManagement


Connect-ExchangeOnline

$results = Get-MailTrafficReport -Direction Inbound  -StartDate 10/01/2020 -EndDate 11/01/2020


$results | select-object 'Event Type', 'Message Count' 


get-type $results
$results

foreach ($r in $results) {
    write-host ($r.'Event Type')




}


| Group-Object 'Event Type' | Out-GridView

$results.count

$results | Group-Object 'Event Type', 'Message Count'




| Select-Object 'Event Type', Direction, {Message Count} |
Group-Object "Event Type" 



|
Select-Object Name, "Message Count".Sum



@{l='Count';e={($_.Group.Size.MegaByte | Measure-Object -Sum).Sum}}



Select-Object Database, TypeDescription, Size |
Group-Object TypeDescription |
Select-Object Name, @{l='Size';e={($_.Group.Size.MegaByte | Measure-Object -Sum).Sum}}