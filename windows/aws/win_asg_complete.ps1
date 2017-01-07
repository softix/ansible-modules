#!powershell
# (c) 2016, Softix Pty Ltd <support@softix.com>

# WANT_JSON
# POWERSHELL_COMMON

$params = Parse-Args $args;
$result = New-Object psobject;
Set-Attr $result "changed" $false;

$asg_name = Get-Attr -obj $params -name "name"
$instance_id = Get-Attr -obj $params -name "instance"
$action_result = Get-Attr -obj $params -name "result"
$hook_name = Get-Attr -obj $params -name "hook"

$changed = $false

Complete-ASLifecycleAction -LifecycleHookName $hook_name -AutoScalingGroupName $asg_name -LifecycleActionResult $action_result -InstanceId $instance_id

Set-Attr -obj $result "changed" $true;

Exit-Json -obj $result
