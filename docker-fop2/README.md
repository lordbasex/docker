# Docker FOP2

Lord BaseX (c) 2014-2020
 Federico Pereira <fpereira@cnsoluciones.com>


### Firewall
```bash
#SSH
firewall-cmd --zone=public --add-port=22/tcp --permanent

#FOP2
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=4445/tcp --permanent

firewall-cmd --reload
firewall-cmd --list-all
```
