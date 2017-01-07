#!powershell
# (c) 2016, Softix Pty Ltd <support@softix.com>

# this is a windows documentation stub.  actual code lives in the .ps1
# file of the same name

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;
$result = New-Object psobject;
Set-Attr $result "changed" $false;

Import-Module WebAdministration

$site = Get-Attr -obj $params -name "site"
$type = Get-Attr -obj $params -name "type"
$enabled_text = Get-Attr -obj $params -name "enabled"

$changed = $false
$current_setting = (Get-WebConfigurationProperty -filter /system.WebServer/security/authentication/$type -Name enabled -PSPath IIS:\Sites\$site).Value

if ($enabled_text -eq "true") {
    $enabled = $true
}
else {
    $enabled = $false
}

if ($enabled -ne $current_setting) {
    Set-WebConfigurationProperty -filter /system.WebServer/security/authentication/$type -Name enabled -PSPath IIS:\Sites\$site -Value $enabled
    $changed = $true
}

if ($changed)
{
    Set-Attr -obj $result "changed" $true;
    Set-Attr -obj $result "type" $type;
    Set-Attr -obj $result "value" $enabled;
}

Exit-Json -obj $result
