#!powershell
# (c) 2016, Softix Pty Ltd <support@softix.com>

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;
$result = New-Object psobject;
Set-Attr $result "changed" $false;

$changed = $false

$url = Get-AnsibleParam -obj $params -name "url" -failifempty $true
$branch = Get-AnsibleParam -obj $params -name "branch" -failifempty $true
$project = Get-AnsibleParam -obj $params -name "project" -failifempty $true
$token = Get-AnsibleParam -obj $params -name "token" -failifempty $true
$dest = Get-AnsibleParam -obj $params -name "destination" -failifempty $true

$headers = @{"PRIVATE-TOKEN" = $token }

$projects = Invoke-RestMethod -Method Get -Uri ($url + "/api/v3/projects?per_page=100") -Headers $headers
$p = $null

foreach ($proj in $projects) {
    if ($proj.path_with_namespace -eq $project) {
        $p = $proj
    }
}

$b = Invoke-RestMethod -Method Get -Uri ($url + "/api/v3/projects/" + $p.id + "/repository/branches/" + $branch) -Headers $headers

$download_url = ($p.web_url + "/repository/archive.zip?ref=" + $branch)

$client = New-Object System.Net.WebClient
$client.Headers.Add("PRIVATE-TOKEN", $token)

$temp_zip = [System.IO.Path]::GetTempFileName()
$temp_path = [System.IO.Path]::GetTempPath()
[string] $guid = [System.Guid]::NewGuid()
$temp_path = (Join-Path $temp_path $guid)
New-Item -ItemType Directory -Path $temp_path
$folder_name = ($p.name + '-' + $branch + '-' + $b.commit.id)
$extracted_root = (Join-Path $temp_path $folder_name)

$client.DownloadFile($download_url, $temp_zip)

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($temp_zip, $temp_path)

New-Item -Path $dest -type Directory
Copy-Item -Recurse $extracted_root\* $dest

Remove-Item $temp_zip
Remove-Item -Recurse $temp_path

if ($changed)
{
    Set-Attr -obj $result "changed" $true;
}

Exit-Json -obj $result
