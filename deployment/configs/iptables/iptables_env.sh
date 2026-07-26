#!/bin/bash

# clean all rules
iptables -t filter -F
iptables -t nat -F
iptables -t mangle -F
iptables -t raw -F
ip6tables -t filter -F
ip6tables -t nat -F
ip6tables -t mangle -F
ip6tables -t raw -F

# clean all user defined chains
iptables -t filter -X
iptables -t nat -X
iptables -t mangle -X
iptables -t raw -X
ip6tables -t filter -X
ip6tables -t nat -X
ip6tables -t mangle -X
ip6tables -t raw -X

# default policies
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
ip6tables -P INPUT DROP
ip6tables -P OUTPUT ACCEPT
ip6tables -P FORWARD DROP

# allow localhost
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
ip6tables -A INPUT  -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT

# allow established/related
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT 
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT 
ip6tables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# block ips v4
ipset create blocked_hosts_v4 iphash -exist # no error if set already exists
ipset -F blocked_hosts_v4 # clean set
for ip in $(cat ./deployment/configs/iptables/blocked_hosts_v4.txt); do
    ipset add blocked_hosts_v4 $ip
done
iptables -A INPUT -p tcp -m set --match-set blocked_hosts_v4 src -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp -m set --match-set blocked_hosts_v4 src -j REJECT --reject-with icmp-port-unreachable
iptables -A FORWARD -p tcp -m set --match-set blocked_hosts_v4 src -j REJECT --reject-with tcp-reset
iptables -A FORWARD -p udp -m set --match-set blocked_hosts_v4 src -j REJECT --reject-with icmp-port-unreachable

# block ips v6
ipset create blocked_hosts_v6 iphash family inet6 -exist # no error if set already exists
ipset -F blocked_hosts_v6 # clean set
for ip in $(cat ./deployment/configs/iptables/blocked_hosts_v6.txt); do
    ipset add blocked_hosts_v6 $ip
done
ip6tables -A INPUT -p tcp -m set --match-set blocked_hosts_v6 src -j REJECT --reject-with icmp6-adm-prohibited
ip6tables -A INPUT -p udp -m set --match-set blocked_hosts_v6 src -j REJECT --reject-with icmp6-adm-prohibited
ip6tables -A FORWARD -p tcp -m set --match-set blocked_hosts_v6 src -j REJECT --reject-with icmp6-adm-prohibited
ip6tables -A FORWARD -p udp -m set --match-set blocked_hosts_v6 src -j REJECT --reject-with icmp6-adm-prohibited

# block nets v4
ipset create blocked_nets_v4 nethash -exist # no error if set already exists
ipset -F blocked_nets_v4 # clean set
for ip in $(cat ./deployment/configs/iptables/blocked_nets_v4.txt); do
    ipset add blocked_nets_v4 $ip
done
iptables -A INPUT -p tcp -m set --match-set blocked_nets_v4 src -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp -m set --match-set blocked_nets_v4 src -j REJECT --reject-with icmp-port-unreachable
iptables -A FORWARD -p tcp -m set --match-set blocked_nets_v4 src -j REJECT --reject-with tcp-reset
iptables -A FORWARD -p udp -m set --match-set blocked_nets_v4 src -j REJECT --reject-with icmp-port-unreachable

# block nets v6
ipset create blocked_nets_v6 nethash family inet6 -exist # no error if set already exists
ipset -F blocked_nets_v6 # clean set
for ip in $(cat ./deployment/configs/iptables/blocked_nets_v6.txt); do
    ipset add blocked_nets_v6 $ip
done
ip6tables -A INPUT -p tcp -m set --match-set blocked_nets_v6 src -j REJECT --reject-with icmp6-adm-prohibited
ip6tables -A INPUT -p udp -m set --match-set blocked_nets_v6 src -j REJECT --reject-with icmp6-adm-prohibited
ip6tables -A FORWARD -p tcp -m set --match-set blocked_nets_v6 src -j REJECT --reject-with icmp6-adm-prohibited
ip6tables -A FORWARD -p udp -m set --match-set blocked_nets_v6 src -j REJECT --reject-with icmp6-adm-prohibited

# allow podman
iptables -A FORWARD -o podman1 -j ACCEPT
iptables -A FORWARD -i podman1 -j ACCEPT
ip6tables -A FORWARD -o podman1 -j ACCEPT
ip6tables -A FORWARD -i podman1 -j ACCEPT
iptables -A INPUT -i podman1 -p udp --dport 53 -j ACCEPT
iptables -A INPUT -i podman1 -p tcp --dport 53 -j ACCEPT
ip6tables -A INPUT -i podman1 -p udp --dport 53 -j ACCEPT
ip6tables -A INPUT -i podman1 -p tcp --dport 53 -j ACCEPT

# allow icmp
iptables -A INPUT -p icmp --icmp-type 8 -m limit --limit 10/s -j ACCEPT # echo request with limit for the whole server
iptables -A OUTPUT -p icmp --icmp-type 0 -m limit --limit 10/s -j ACCEPT # echo reply with limit for the whole server
ip6tables -A INPUT -p ipv6-icmp --icmpv6-type 128 -m limit --limit 10/s -j ACCEPT # echo request with limit for the whole server
ip6tables -A OUTPUT -p ipv6-icmp --icmpv6-type 129 -m limit --limit 10/s -j ACCEPT # echo reply with limit for the whole server

# allow SSH
iptables -A INPUT -p tcp --dport $SSH_PORT -j ACCEPT
ip6tables -A INPUT -p tcp --dport $SSH_PORT -j ACCEPT

# drop invalid packages
iptables -A INPUT  -m state --state INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP
ip6tables -A INPUT  -m state --state INVALID -j DROP
ip6tables -A OUTPUT -m state --state INVALID -j DROP

# default rules
iptables -A INPUT -p tcp -j REJECT --reject-with tcp-reset
iptables -A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
ip6tables -A INPUT -p tcp -j REJECT --reject-with icmp6-port-unreachable
ip6tables -A INPUT -p udp -j REJECT --reject-with icmp6-port-unreachable
