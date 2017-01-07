#!powershell
# (c) 2016, Softix Pty Ltd <support@softix.com>

# this is a windows documentation stub.  actual code lives in the .ps1
# file of the same name

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;
$result = New-Object psobject;
Set-Attr $result "changed" $false;
Set-Attr -obj $result -name "joined_domain" -value $false

$domain = Get-Attr -obj $params -name "domain"
$username = Get-Attr -obj $params -name "username"
$password = Get-Attr -obj $params -name "password"
$oupath = Get-Attr -obj $params -name "ou_path"

# TODO: add in validation that variables are being set

if ((gwmi win32_computersystem).partofdomain -eq $true) {
    Set-Attr -obj $result "already_joined" $true;
    Exit-Json -obj $result
} else {
    $secstr = New-Object -TypeName System.Security.SecureString
    $password.ToCharArray() | ForEach-Object {$secstr.AppendChar($_)}
    $userdomain = $username + "@" + $domain
    $cred = New-Object -typename System.Management.Automation.PSCredential -argumentlist $userdomain, $secstr
    Add-Computer -DomainName $domain -OUPath $oupath -Force -Credential $cred

    if ((gwmi win32_computersystem).partofdomain -eq $true) {
        Set-Attr -obj $result "changed" $true;
        Set-Attr -obj $result "joined_domain" $true;
    } else {
    }

    Exit-Json -obj $result
}
