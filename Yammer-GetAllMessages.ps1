## https://www.nubo.eu/Get-All-Yammer-Messages-Through-Rest-API-With-PowerShell/

$config = (Import-PowerShellDataFile "C:\dev\config\config.psd1")
$baererToken = $config.YammerBaererToken

$yammerBaseUrl = "https://www.yammer.com/api/v1"



Function Get-BaererToken() {
    $headers = @{ Authorization=("Bearer " + $baererToken) }
    return $headers
}

Function Get-YamMessages($limit, $allMessages, $lastMessageId) {
    $yammerBatchSize = 20;
    if ($limit -eq $null) {
        $threadLimit = $yammerBatchSize
    }
    else {
        $threadLimit = $limit
    }

    if ($allMessages -eq $null) {
        $allMessages = New-Object System.Collections.ArrayList($null)
    }

    $currentMessageCount = $allMessages.Count;

    if ($currentMessageCount -ge $threadLimit) {
        return $allMessages
    } elseif ($currentMessageCount + $yammerBatchSize -gt $threadLimit) {
        $threadLimit = $threadLimit % $yammerBatchSize;
    } else {
        $threadLimit = $yammerBatchSize
    }

    $urlToCall = "$($yammerBaseUrl)/messages.json"
    $urlToCall += "?limit=" + $threadLimit;
    if ($lastMessageId -ne $null) {
        $urlToCall += "&older_than=" + $lastMessageId;
    }
   
    $headers = Get-BaererToken
    Write-Host $urlToCall
    $webRequest = Invoke-WebRequest -Uri $urlToCall -Headers $headers -Method Get

    if ($webRequest.StatusCode -eq 200) {
        $results = $webRequest.Content | ConvertFrom-Json
        if ($results.messages.Length -eq 0) {
            return $allMessages
        }
        $allMessages.AddRange($results.messages)
    }

    if ($allMessages.Count -lt $limit) {
        $lastMessageId = $allMessages[$allMessages.Count -1].id;
        return Get-YamMessages $limit $allMessages $lastMessageId
    }
    else {
        return $allMessages
    }
}


Function Get-YamUsers($page, $allUsers) {
    if ($page -eq $null) {
        $page = 1
    }

    if ($allUsers -eq $null) {
        $allUsers = New-Object System.Collections.ArrayList($null)
    }

    $urlToCall = "$($yammerBaseUrl)/users.json"
    $urlToCall += "?page=" + $page;

    $headers = Get-BaererToken

    Write-Host $urlToCall
    $webRequest = Invoke-WebRequest -Uri $urlToCall -Method Get -Headers $headers

    if ($webRequest.StatusCode -eq 200) {
        $results = $webRequest.Content | ConvertFrom-Json

        if ($results.Length -eq 0) {
            return $allUsers
        }
        $allUsers.AddRange($results)
    }

    if ($allUsers.Count % 50 -eq 0) {
        $page = $page + 1
        return Get-YamUsers $page $allUsers
    }
    else {
        return $allUsers
    }
}




$messageResults = ""
$messageResults = Get-YamMessages 10000
$messageResults.count

$users = Get-YamUsers
$users | Out-GridView


$messageResults | where-object {$_.Body -like "*sex*"} | Out-GridView

$users | where-object {$_.id -eq 1504186124 } | select-object email

$sexyposts = foreach ($m in ($messageResults | where-object {$_.Body -like "*sex*"})) {
    ##write-host $m.body
    $createdAt = $m.created_at
    $message = $m.body
    $poster = ($users | where-object {$_.id -eq $m.sender_id} | select-object -ExpandProperty email )

    [pscustomobject]@{
        createdad = $createdAt
        poster    = $poster
        message     = $message
    }
}

$sexyposts | Export-Csv -Path c:\temp\sexyposts.csv -NoTypeInformation