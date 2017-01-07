#!powershell
# (c) 2016, Softix Pty Ltd <support@softix.com>

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;
$result = New-Object psobject;
Set-Attr $result "changed" $false;

$path = Get-Attr -obj $params -name "path"
$name = Get-Attr -obj $params -name "name"
$value = Get-Attr -obj $params -name "value"

$current = Get-WebConfigurationProperty $path -name $name
$changed = $false

if ($current.Value -ne $value)
{
    Set-WebConfigurationProperty $path -name $name -value $value
    $changed = $true
}

if ($changed)
{
    Set-Attr -obj $result "changed" $true;
}

Exit-Json -obj $result
