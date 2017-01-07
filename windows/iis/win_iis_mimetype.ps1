#!powershell
# (c) 2016, Softix Pty Ltd <support@softix.com>

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;
$result = New-Object psobject;
Set-Attr $result "changed" $false;

Import-Module WebAdministration

$extension = Get-Attr -obj $params -name "extension"
$mime_type = Get-Attr -obj $params -name "mime_type"

$changed = $false
$current_setting = ((Get-WebConfiguration '//staticContent').collection | ? {$_.fileextension -eq $extension})

if ($current_setting) {
    if (!($current_setting.mimeType -eq $mime_type)) {
        Set-WebConfigurationProperty -filter "//staticContent/mimeMap[@fileExtension=$extension]" -PSPath I\IS:\ -Name mimeType -Value $mime_type
        $changed = $true
    }
}
else {
    Add-WebConfigurationProperty '//staticContent' -name collection -value @{fileExtension=$extension; mimeType=$mime_type}
    $changed = $true
}

if ($changed)
{
    Set-Attr -obj $result "changed" $true;
    Set-Attr -obj $result "mime_type" $mime_type;
    Set-Attr -obj $result "extension" $extension;
}

Exit-Json -obj $result
