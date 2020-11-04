Connect-MsolService

$users = Get-MsolRoleMember -RoleObjectId $(Get-MsolRole -RoleName "Company Administrator").ObjectId 
$users | Out-GridView



