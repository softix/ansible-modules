#!powershell
# (c) 2016, Softix Pty Ltd <support@softix.com>

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;
$result = New-Object psobject;
Set-Attr $result "changed" $false;

$changed = $true

C:\Windows\system32\inetsrv\appcmd.exe set config -section:system.applicationHost/sites /siteDefaults.logFile.logExtFileFlags:"BytesRecv, BytesSent, ClientIP, ComputerName, Cookie, Date, Host, HttpStatus, HttpSubStatus, Method, ProtocolVersion, Referer, ServerIP, ServerPort, SiteName, Time, TimeTaken, UriQuery, UriStem, UserAgent, UserName, Win32Status" /commit:apphost

if ($changed)
{
    Set-Attr -obj $result "changed" $true;
}

Exit-Json -obj $result
