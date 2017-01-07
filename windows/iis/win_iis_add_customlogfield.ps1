#!powershell
# (c) 2016, Softix Pty Ltd <support@softix.com>

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;
$result = New-Object psobject;
Set-Attr $result "changed" $false;

$name = Get-Attr -obj $params -name "name"
$source = Get-Attr -obj $params -name "source"
$type = Get-Attr -obj $params -name "type"

$changed = $false
$current_fields = (Get-WebConfiguration -filter /system.applicationHost/sites/siteDefaults/logFile/customFields -pspath 'MACHINE/WEBROOT/APPHOST').Collection
$has_field = $false

foreach ($field in $current_fields) {
    if ($field.logFieldName -eq $name) {
        $has_field = $true
        break
    }
}

if ($has_field) {
    if ($field.sourceName -ne $source) {
        $changed = $true
        # TO DO..
    }

    if ($field.sourceType -ne $type) {
        $changed = $true
        # TO DO..
    }
}
else {
    add-webconfiguration `
        -filter /system.applicationHost/sites/siteDefaults/logFile/customFields `
        -pspath 'MACHINE/WEBROOT/APPHOST' `
        -value @{logFieldName=$name;sourceName=$source;sourceType=$type} -atindex 0
}

if ($changed)
{
    Set-Attr -obj $result "changed" $true;
}

Exit-Json -obj $result
