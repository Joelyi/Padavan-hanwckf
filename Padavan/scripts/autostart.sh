#!/bin/sh
#nvram set ntp_ready=0
SMARTDNS_CONF="/etc/storage/smartdns_custom.conf"
DNSMASQ_CONF="/etc/storage/dnsmasq/dnsmasq.conf"
SMARTDNS_INI="/etc/storage/smartdns_conf.ini"
SDNS_PORT=$(nvram get sdns_port)
if [ $(nvram get sdns_enable) = 1 ] ; then
   if [ -f "$SMARTDNS_CONF" ] ; then
       sed -i '/去广告/d' "$SMARTDNS_CONF"
       sed -i '/adbyby/d' "$SMARTDNS_CONF"
       sed -i '/no-resolv/d' "$DNSMASQ_CONF"
       sed -i '/server=127.0.0.1#'"$SDNS_PORT"'/d' "$DNSMASQ_CONF"
       sed -i '/port=0/d' "$DNSMASQ_CONF"
       rm  -f "$SMARTDNS_INI"
   fi
logger -t "自动启动" "正在启动SmartDNS"
/usr/bin/smartdns.sh start
fi

logger -t "自动启动" "正在检查路由是否已连接互联网！"
count=0
while :
do
	ping -c 1 -W 1 -q www.baidu.com 1>/dev/null 2>&1
	if [ "$?" == "0" ]; then
		break
	fi
	ping -c 1 -W 1 -q 202.108.22.5 1>/dev/null 2>&1
	if [ "$?" == "0" ]; then
		break
	fi
	sleep 5
	ping -c 1 -W 1 -q www.google.com 1>/dev/null 2>&1
	if [ "$?" == "0" ]; then
		break
	fi
	ping -c 1 -W 1 -q 8.8.8.8 1>/dev/null 2>&1
	if [ "$?" == "0" ]; then
		break
	fi
	sleep 5
	count=$((count+1))
	if [ $count -gt 18 ]; then
		break
	fi
done

