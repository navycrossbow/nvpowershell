

$config = (Import-PowerShellDataFile "C:\dev\config\config.psd1")


Connect-ExchangeOnline

$results = Search-AdminAuditLog -StartDate "11/1/2020 8:00 AM" -EndDate "11/2/2020 8:00 PM"
$results | Out-GridView 

$adminUpn = $config.AdminUpn
$results = Search-AdminAuditLog -StartDate "10/1/2020 8:00 AM" -EndDate "10/15/2020 8:00 PM" -UserIds $adminUpn
$results | Out-GridView 