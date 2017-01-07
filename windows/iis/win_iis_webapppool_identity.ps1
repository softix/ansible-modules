#!powershell
# (c) 2016, Softix Pty Ltd <support@softix.com>

# this is a windows documentation stub.  actual code lives in the .ps1
# file of the same name

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;
$result = New-Object psobject;
Set-Attr $result "changed" $false;
Set-Attr -obj $result -name "updated_identity" -value $false

Import-Module WebAdministration

$app_pool = Get-Attr -obj $params -name "application_pool"
$username = Get-Attr -obj $params -name "username"
$password = Get-Attr -obj $params -name "password"
$identity_type = Get-Attr -obj $params -name "identity_type"

# TODO: add in validation that variables are being set
$appPool = Get-Item "IIS:\AppPools\$app_pool"

$changed = $false

if ($appPool.processModel.identityType -ne $identity_type)
{
    Set-ItemProperty "IIS:\AppPools\$app_pool" processModel.identityType $identity_type
    $changed = $true
}

if ($appPool.processModel.userName -ne $username)
{
    Set-ItemProperty "IIS:\AppPools\$app_pool" processModel.userName "$username"
    $changed = $true
}

if ($appPool.processModel.password -ne $password)
{
    Set-ItemProperty "IIS:\AppPools\$app_pool" processModel.password "$password"
    $changed = $true
}

if ($changed)
{
    Set-Attr -obj $result "changed" $true;
    Set-Attr -obj $result "updated_identity" $true;
}

Exit-Json -obj $result
