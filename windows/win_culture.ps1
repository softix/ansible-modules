#!powershell
# (c) 2016, Softix Pty Ltd <support@softix.com>

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;
$result = New-Object psobject;
Set-Attr $result "changed" $false;

$culture = Get-Attr -obj $params -name "name"

$current_culture = Get-Culture
$current_locale = Get-WinSystemLocale

Set-Attr -obj $result "culture" $current_culture.Name;
Set-ATtr -obj $result "locale" $current_locale.Name;

$changed = $false

if ($current_culture.Name -ne $culture)
{
    Set-Culture $culture
    $changed = $true
}

if ($current_locale.Name -ne $culture)
{
    Set-WinSystemLocale $culture
    $changed = $true
}


if ($changed)
{
    Set-Attr -obj $result "changed" $true;
    Set-Attr -obj $result "culture" $culture;
    Set-Attr -obj $result "locale" $culture;
}

Exit-Json -obj $result
