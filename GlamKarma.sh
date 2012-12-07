#!/bin/bash
# A script to autostart hostapd-1.0-karma 
# and dhcp3-server to serve ip addresses to clients
# also sets up iptables rules to forward clients traffic
# Made By Joshua Taylor
$hostapdpath=//root/hostapd-1.0-karma/hostapd
interface=$1
$mydir=pwd
if ( $1=NULL )
{
	echo "Glam Karma V0.1 - Created by Joshua Taylor - taylorjoshu00@googlemail.com\n"
	echo "Usage: ./GlamKarma.sh wlan0\n"
	echo "Starts hostapd-1.0-karma and dhcp3-server to run and collect clients "

}

cat $mydir/banner
echo "Starting hostapd on interface $interface"

cd $hostapdpath

echo "interface=$interface
driver=nl80211
ssid=BarStucksWifi
channel=1

# Both open and shared auth
auth_algs=3

# no SSID cloaking
ignore_broadcast_ssid=0

# -1 = log all messages
logger_syslog=-1
logger_stdout=-1

# 2 = informational messages
logger_syslog_level=2
logger_stdout_level=2

# Dump file for state information (on SIGUSR1)
# example: kill -USR1 <pid>
dump_file=/tmp/hostapd.dump
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0

# 0 = accept unless in deny list
macaddr_acl=0

# only used if you want to do filter by MAC address
#accept_mac_file=/etc/hostapd/hostapd.accept
#deny_mac_file=/etc/hostapd/hostapd.deny

# Finally, enable Karma
enable_karma=1

# Black and white listing
# 0 = while
# 1 = black
karma_black_white=1
" >> hostapd.conf

xterm -geometry 75x15+1+0 -T "./hostapd -dd hostapd.conf" & karmapid=$!

echo "starting dhcp3-server"

xterm -geometry 75x15+1+0 -T "dhcp3-server -f -cf dhcpdkarma.conf" & dhcp3pid=$!



echo "To shut down GlamKarma properly press 'y' - Please note if it is not shut down correctly then some services may still remain running"
read WISH
if [$WISH = y] ; then
echo "Cleaning up GlamKarma and Shutting down...."
kill ${karmapid}
kill ${dhcp3pid}
echo "0" > /proc/sys/net/ipv4/ip_forward
iptables --flush
iptables --table nat --flush
iptables --delete-chain
iptables --table nat --delete-chain

echo "GlamKarma house keeping complete, GoodBye!"
