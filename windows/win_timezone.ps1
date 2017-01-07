#!powershell
# (c) 2016, Softix Pty Ltd <support@softix.com>

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;
$result = New-Object psobject;
Set-Attr $result "changed" $false;

$timezone = Get-Attr -obj $params -name "timezone"

$current = [System.TimeZone]::CurrentTimeZone

Set-Attr -obj $result "timezone" $current.StandardName;

$changed = $false

if ($current.StandardName -ne $timezone)
{
    tzutil.exe /s $timezone
    $changed = $true
}

if ($changed)
{
    Set-Attr -obj $result "changed" $true;
    Set-Attr -obj $result "timezone" $timezone;
}

Exit-Json -obj $result
