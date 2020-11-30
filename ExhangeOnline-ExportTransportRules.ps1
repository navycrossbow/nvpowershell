
Import-Module ExchangeOnlineManagement


Connect-ExchangeOnline


$file = Export-TransportRuleCollection; Set-Content -Path "C:\Temp\ExchangeOnlineRules.xml" -Value $file.FileData -Encoding Byte
