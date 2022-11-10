# Monitoring

Prometheus is a tool to monitor servers.

## Create VMs that we want to monitor

We will create 3 VMs for this cluster.

- monitor
- client1
- client2


## Create the VMs

Create all VMs using the script `../kvm/files/centos/create_centos_kvm.sh`. Open 3 tabs in your terminal and run:

```
cd  ../kvm/files/centos
sh ./create_centos_kvm.sh monitor 30G
sh ./create_centos_kvm.sh client1 30G
sh ./create_centos_kvm.sh client2 30G
``` 

## Enable public key authentication

The VMs will automatically update itself to the latest packages. This is the behavior of VMs created using cloud-init. Afterwards, we need to configure each VM for SSH.

1. Login to each VM from the console using root user and the root password (see the create_centos_kvm.sh script for the location and value). Then edit /etc/ssh/sshd_config to allow root login and password auth. These are defined in the PermitRootLogin and PasswordAuthentication properties. Once set, run `systemctl restart sshd`.

3. Net, run `ssh-keygen to generate SSH public and private keys.

4. Copy and paste our host's public key to /root/.ssh/authorized_keys in each VM, or use ssh-copy-id (making not of the IP address of each VM).

The VMs are configured with DHCP by default, so in the next step we will set static IPs.

## Configure networking and reboot

Let's change the IP addresses of our VMs. We should set it to the following:

- monitor: 192.168.1.23
- client1: 192.168.1.24
- client2: 192.168.1.25

Edit /etc/sysconfig/network-scripts/ifcfg-eth0 with a static IP address. Note that these IP addresses are outside the range of my switch.

For monitor:

```
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
ONBOOT="yes"
NM_CONTROLLD="no"
NETBOOT=no
IPV6INIT="yes"
BOOTPROTO="none"
TYPE="Ethernet"
NAME="eth0"
DNS1="8.8.8.8"
IPADDR="192.168.1.23"
NETMASK="255.255.255.0"
EOF
```

For client1:

```
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
ONBOOT="yes"
NM_CONTROLLD="no"
NETBOOT=no
IPV6INIT="yes"
BOOTPROTO="none"
TYPE="Ethernet"
NAME="eth0"
DNS1="8.8.8.8"
IPADDR="192.168.1.24"
NETMASK="255.255.255.0"
EOF
```

For client2:

```
cat << EOF > /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
ONBOOT="yes"
NM_CONTROLLD="no"
NETBOOT=no
IPV6INIT="yes"
BOOTPROTO="none"
TYPE="Ethernet"
NAME="eth0"
DNS1="8.8.8.8"
IPADDR="192.168.1.25"
NETMASK="255.255.255.0"
EOF
```

For all VMs, stop and disable NetworkManager (if it's running)

```
{
    systemctl stop NetworkManager
    systemctl disable NetworkManager
}
```

For all VMs, set the default gateway.

```
cat << EOF > /etc/sysconfig/network
GATEWAY=192.168.1.1
EOF
```

For all VMs, set the FQDN.

For monitor:

```
hostnamectl set-hostname monitor.zaxworld.net
```

For client1:

```
hostnamectl set-hostname client1.zaxworld.net
```

For client2:

```
hostnamectl set-hostname client2.zaxworld.net
```

Also set the hostname in /etc/hosts.

For monitor:

```
cat << EOF > /etc/hosts
127.0.0.1 localhost
::1 localhost
192.168.1.23 monitor monitor.zaxworld.net
EOF
```

For client1:

```
cat << EOF > /etc/hosts
127.0.0.1 localhost
::1 localhost
192.168.1.24 client1 client1.zaxworld.net
EOF
```

For client2:

```
cat << EOF > /etc/hosts
127.0.0.1 localhost
::1 localhost
192.168.1.25 client2 client2.zaxworld.net
EOF
```

Finally reboot all VMs. The hostname should be changed for each VM.

On your localhost, add entries for each host in /etc/hosts:

```
192.168.1.23 monitor monitor.zaxworld.net
192.168.1.24 client1 client1.zaxworld.net
192.168.1.25 client2 client2.zaxworld.net
```

Reboot all three VMs. 

Finally SSH to each VM as root.

```
ssh root@monitor
ssh root@client1
ssh root@client2
```

## Install and start prometheus

On the monitor VM, download and extract the latest release of Prometheus at https://prometheus.io/download/

# Installing prometheus-node-exporter

On each of the machines, download and install the Exporter from the download page. To start the node exporter, just cd to the directory and run:

```
./node_exporter &
```

## Prometheus configuration

Copy *files/prometheus.yml* to monitor that can scrape our three machines.

```
global:
  scrape_interval: 10s

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter_metrics'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100', 'client1:9100', 'client2:9100']
```

Note that Prometheus is exposing metrics on port 9090, while the node exporter exposes metrics on port 9100.

Also on monitor, add entries for the other two VMs in /etc/hosts:

```
192.168.1.24	client1 client1.zaxworld.net
192.168.1.25	client2 client2.zaxworld.net
```

Afterwards, start prometheus. For example:

```
./prometheus-2.30.3.linux-amd64/prometheus 
```

Now visit http://monitor:9090/targets in your browser.

## Alerting

Copy prometheus_rules.yml and prometheus_with_alerts.yml to monitor. 

```
scp prometheus_rules.yml root@monitor:
scp prometheus_with_alerts.yml root@monitor:
```

To validate, run:

```
./prometheus-2.40.1.linux-amd64/promtool check rules prometheus_rules.yml 
```

Now copy this file to the monitor server and restart Prometheus with the updated config file.

```
./prometheus-2.40.1.linux-amd64/prometheus --config.file=prometheus_with_alerts.yml
```

Then go to http://monitor:9090/alerts to see the alert. You can also see your targets at http://monitor:9090/targets. 

You can trigger the alert by shutting down a node exporter. After one minute, an instance will be down.

Note: you can test the UP rule by going to Prometheus at http://monitor:9090 and entering a query with 'up'. If you notice some zeros, that means the node exporter is down and you should start it.

Next, we need to install AlertManager. Download AlertManager from https://prometheus.io/download/ on monitor. 

Copy alertmanager.yml to the monitor and verify it.

```
/alertmanager-0.23.0.linux-amd64/amtool check-config alertmanager.yml
```

Next, run alertmanager.

```
./alertmanager-0.24.0.linux-amd64/alertmanager &
```

Once it's running, you can go to http://monitor:9093 and check the status of AlertManager.

In Prometheus, go to http://monitor:9090/status and you can see AlertManager. If it's blank, make sure the config file in prometheus_with_alerts.yml is pointing to the AlertManager like so:

```
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - localhost:9093
```

That's it for alerting with Prometheus!

## Grafana

Install grafana on localhost. To start it, start the grafana service.

Afterwards, I was able to go to http://localhost:3000, login as admin/admin. Once logged in, I went to datasources | Prometheus, set the URL to http://monitor:9100, click *Save and Test* and we should be successful. 

To add a dashboard, I went to Dashboards | Manage | Import and import dashboards. Some popular dashboards are:

- https://grafana.com/grafana/dashboards/10242 (to see one host's details at a time)

- https://grafana.com/grafana/dashboards/1860 (another dashobard to see a host's details)
- https://grafana.com/grafana/dashboards/11074 (to see a list of machines)

To see what would happen if a host went down, shutdown client1.

```
sudo virsh shutdown client1
```

Then if you refresh dashboard 11074, you'll see that client1 is down.

#### Step 2: Serving Grafana behind a reverse proxy

Initially, my goal was to use Nginx to serve as a reverse proxy. That way, I could set up HTTPS using Let's Encrypt. However, browsers are very picky about accessing website s secured with self-signed certificates, so the instructions below are just to serve Grafana through HTTP.

First I installed nginx on zaxman. The package is called *nginx-mainline* to distinguish it from the more stable (but not recommneded) release. 

For this setup, I closely followed https://grafana.com/tutorials/run-grafana-behind-a-proxy/.

1. In **grafana.ini**, I set the following line as the public facing URL:

```
root_url = %(protocol)s://%(domain)s:%(http_port)s/grafana/
```

2. Next, restart grafana.

```
systemctl restart grafana
```

3. Edit **nginx.conf** and add the following line to the end of the **http** block. Note that the trailing */* is required.

```
  location /grafana/ {
   proxy_pass http://zaxman.zaxworld.net:3000/;
  }
```

2. Test for validness

```
nginx -t
```

3. Reload nginx. This step is actually important and is not enough to just restart nginx for changes to be read.

```
systemctl reload nginx
```

4. Now you should be able to go to *http://zaxman.zaxworld.net/grafana*.


### Firewall settings for Grafana

On zxaxman, I use gufw to configure ufw. I set the default policy for incoming traffic to Deny, then open ports one by one. Hence, we only need to open port 80 since we access Grafana using the reverse proxy.

```
Status: active

To                         Action      From
--                         ------      ----
80/tcp                     ALLOW       Anywhere                  
80/tcp (v6)                ALLOW       Anywhere (v6)
```

### Securing Headers

An annoying feature of nginx is that it will print the version in request headers. You can see these when you go to http://zaxman.zaxworld.net directly. To prevent displaying these headers, you can add *server_tokens off;* in the *http* section of nginx and reload nginx.

However, this will still include *nginx* in the header. To prevent this, I installed *https://aur.archlinux.org/packages/nginx-mainline-mod-headers-more/*. My nginx.conf file now looks like this:

```
load_module /usr/lib/nginx/modules/ngx_http_headers_more_filter_module.so;
server_tokens off;
more_clear_headers Server;
server {
  ...
}
```

This will still return a page with nginx when browsing to *http://zaxman.zaxworld.net* but it will not print the version.

## Securing Grafana

We will secure the Nginx proxy by using self-signed certificates.

1. Generate self-signed certificates

```
cd nginx-proxy
mkdir certs
openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out zaxman.crt -keyout zaxman.key
```

2. Copy these to /etc/ssl/nginx

```
sudo mkdir -p /etc/ssl/nginx
sudo cp certs/* /etc/ssl/nginx
```

3. Change the upstream configuration for Grafana under `/etc/nginx/sites-available/grafana.conf`. It should now look like:

```
server {
  listen      80;
  listen      [::]:80 ipv6only=on;
  server_name zaxman.zaxworld.net;
  root /usr/share/nginx/www;
  index index.html index.htm;
  
  location /grafana/ {
   proxy_pass http://192.168.10.102:3000/;
   proxy_ssl_certificate /etc/ssl/nginx/zaxman.crt;
   proxy_ssl_certificate_key /etc/ssl/nginx/zaxman.key;
   proxy_ssl_session_reuse on;

   proxy_set_header Host $host;
   proxy_set_header X-Real-IP $remote_addr;
   proxy_set_header X-Forwarded-Host $host;
   proxy_set_header X-Forwarded-Server $host;
   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
```

Next we change the server configuration.

```
    server {
        listen       443 ssl;
        server_name  zaxman.zaxworld.net;

	ssl_certificate /etc/ssl/nginx/zaxman.crt;
	ssl_certificate_key /etc/ssl/nginx/zaxman.key;
...
```

Afterwards, we can change our UFW firewall settings. Before we had a setting that said *80/tcp ALLOW IN 192.168.10.0/24*.

## References

https://www.virtono.com/community/tutorial-how-to/how-to-install-and-configure-prometheus-on-a-linux-server/


https://copr.fedorainfracloud.org/coprs/ibotty/prometheus-exporters/

https://www.youtube.com/watch?v=4IAtwCmG6cs&t=140s

https://www.youtube.com/watch?v=a5wGy27cuBQ

https://www.youtube.com/watch?v=jxMq6GiQ5jA&t=285s