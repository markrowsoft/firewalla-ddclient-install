# firewalla-ddclient-install
A shell script t###install ddclient for Firewalla Gold routers that will re-install it upon the Firewalla service restart / reboot


- First you will need t###ssh t###your Firewalla:

https://help.firewalla.com/hc/en-us/articles/115004397274-How-to-access-Firewalla-using-SSH-

How t###access Firewalla using SSH?
Tap on the top right gears button.
Tap on "Advanced"
Tap on "Configurations"
Tap on "SSH Console"
Tap on the "*****"
If it's the first time you using SSH, please tap on "Reset Password" before you start.
Tap on "Reveal Password"
Tap on "Apply To" t###enable SSH on specific networks.

T###automatically install when the Firewalla Service is restarted we need to:
https://help.firewalla.com/hc/en-us/articles/360054056754-Customized-Scripting-

- create this directory : ~/.firewalla/config/post_main.d
```bash
mkdir ~/.firewalla/config/post_main.d; cd ~/.firewalla/config/post_main.d
```
- clone this repo

```bash
git clone https://github.com/markrowsoft/firewalla-ddclient-install ./
```

- Each Registrar has specific steps.  I have only setup [Google Domains](https://support.google.com/domains/answer/6147083?hl=en)
- edit this file `ddclient.conf`

```
vim ~/.firewalla/config/post_main.d/ddclient.conf
```
- I have included the examples of the ddclient help command in the ddclient.conf file. Uncomment and configure.

Here is the configuration I used for my Google Domains:
```
# /etc/ddclient.conf
ssl=yes
protocol=googledomains
use=if, if=pppoe0
server=domains.google.com
login=yourgeneratedHostDDNSuserid
password='yourgeneratedpassword'
hostname-to-be-updated.com
```

- edit `etc-default-ddclient`

I used `ppp` setting but set what you need.

```
# Configuration for ddclient scripts 
# generated from debconf on Fri Jul 23 11:59:44 EDT 2021
#
# /etc/default/ddclient

# Set to "true" if ddclient should be run every time DHCP client ('dhclient'
# from package isc-dhcp-client) updates the systems IP address.
run_dhclient="false"

# Set to "true" if ddclient should be run every time a new ppp connection is 
# established. This might be useful, if you are using dial-on-demand.
run_ipup="true"

# Set to "true" if ddclient should run in daemon mode
# If this is changed to true, run_ipup and run_dhclient must be set to false.
run_daemon="true"

# Set the time interval between the updates of the dynamic DNS name in seconds.
# This option only takes effect if the ddclient runs in daemon mode.
daemon_interval="300"
```

- Run `./ddclient.sh`

```bash
pi@firewalla:~/.firewalla/config/post_main.d (mfw) $ ./ddclient.sh 
Hit:1 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:2 http://us.archive.ubuntu.com/ubuntu bionic InRelease
Get:3 http://us.archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:4 http://us.archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Get:5 http://us.archive.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
Fetched 252 kB in 2s (151 kB/s)                               
Reading package lists... Done
Reading package lists...
Building dependency tree...
Reading state information...
ddclient is already the newest version (3.8.3-1.1ubuntu1).
0 upgraded, 0 newly installed, 0 to remove and 259 not upgraded.
● ddclient.service - LSB: Update dynamic domain name service entries
   Loaded: loaded (/etc/init.d/ddclient; generated)
   Active: active (running) since Fri 2021-07-23 13:39:55 EDT; 55ms ago
     Docs: man:systemd-sysv-generator(8)
  Process: 16517 ExecStop=/etc/init.d/ddclient stop (code=exited, status=0/SUCCESS)
  Process: 16523 ExecStart=/etc/init.d/ddclient start (code=exited, status=0/SUCCESS)
    Tasks: 1 (limit: 4529)
   CGroup: /system.slice/ddclient.service
           └─16542 ddclient - sleeping for 300 seconds

Jul 23 13:39:55 firewalla systemd[1]: Starting LSB: Update dynamic domain name service entries...
Jul 23 13:39:55 firewalla systemd[1]: Started LSB: Update dynamic domain name service entries.
....
SENDING:   
RECEIVE:  HTTP/1.1 200 OK
RECEIVE:  Content-Type: text/html
RECEIVE:  Server: DynDNS-CheckIP/1.0.1
RECEIVE:  Connection: close
RECEIVE:  Cache-Control: no-cache
RECEIVE:  Pragma: no-cache
RECEIVE:  Content-Length: 107
RECEIVE:  
RECEIVE:  <html><head><title>Current IP Check</title></head><body>Current IP Address: 158.115.162.161</body></html>
use=web, web=dyndns address is 1.2.3.4
CONNECT:  dns.loopia.se
CONNECTED:  using HTTP
SENDING:  GET /checkip/checkip.php HTTP/1.0
SENDING:   Host: dns.loopia.se
SENDING:   User-Agent: ddclient/3.8.3
SENDING:   Connection: close
SENDING:   
RECEIVE:  HTTP/1.1 200 OK
RECEIVE:  Server: nginx
RECEIVE:  Date: Fri, 23 Jul 2021 17:39:57 GMT
RECEIVE:  Content-Type: text/html; charset=UTF-8
RECEIVE:  Connection: close
RECEIVE:  
RECEIVE:  <html><head><title>Current IP Check</title></head><body>Current IP Address: 1.2.3.4</body></html>
use=web, web=loopia address is 1.2.3.4

```



# !! Use at your own risk.  
If you have any suggestions on improvments, please do. I put this together quickly and there may be mistakes.

-- NOTE: On reboot, ddclient automatically installs BUT firewalla strips the google login information.
Will post update after I research how to store secrets or tokens.

 