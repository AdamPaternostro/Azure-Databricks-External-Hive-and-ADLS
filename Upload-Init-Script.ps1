param
(
    [parameter(Mandatory = $true)] [String] $file,
    [parameter(Mandatory = $true)] [String] $location,
    [parameter(Mandatory = $true)] [String] $databricksAccessToken
)
$location = $location.replace(" ",'').toLower()
# You can write your azure powershell scripts inline here. 
# You can also pass predefined and custom variables to this script using arguments
$path = Split-path $file
$filename = Split-path -leaf $file

$uri ="https://$location.azuredatabricks.net/api/2.0/dbfs/put"
$hdrs = @{}
$hdrs.Add("Authorization","Bearer $databricksAccessToken")
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "Replacing CRLF with LF for $file"
$text = [IO.File]::ReadAllText($file) -replace "`r`n", "`n"
[IO.File]::WriteAllText($file, $text)

Write-Host "Encoding $file to BASE64"
$BinaryContents = [System.IO.File]::ReadAllBytes($File)
$EncodedContents = [System.Convert]::ToBase64String($BinaryContents)
$targetPath  = "/databricks/init/$filename"
$Body = @"
{
    "contents": "$EncodedContents",
    "path": "$targetPath",
    "overwrite": "true"
}
"@

Write-Output "Pushing file $File to $TargetPath to REST API: $uri"
Invoke-RestMethod -Uri $uri -Body $Body -Method 'POST' -Headers $hdrs

