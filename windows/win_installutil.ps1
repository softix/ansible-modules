#!powershell
# (c) 2016, Softix Pty Ltd <support@softix.com>

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;
$result = New-Object psobject;
Set-Attr $result "changed" $false;

$path = Get-Attr -obj $params -name "path"

$changed = $true
$counter = 0

Get-ChildItem $path -Filter *.dll | Foreach-Object {
  C:\Windows\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe $_.FullName
  C:\Windows\Microsoft.NET\Framework64\v4.0.30319\InstallUtil.exe $_.FullName
  $counter++
}


if ($changed)
{
    Set-Attr -obj $result "changed" $true;
    Set-Attr -obj $result "files" $counter
}

Exit-Json -obj $result
