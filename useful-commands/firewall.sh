# Firewall
# Some commands about Linux Firewall. iptables, nftables ...

# ensure netfilter is enabled: (保证netfilter模块是开启的)
grep CONFIG_NETFILTER= /boot/*config*
# you will see "CONFIG_NETFILTER=y" if it is enabled (看到结果"CONFIG_NETFILTER=y")
# else: https://unix.stackexchange.com/questions/316521/how-to-enable-config-netfilter-in-kernel

# iptables

iptables -F # iptables --flush  # delete/wipe all rules 删掉所有规则
iptables -P INPUT DROP # set default policy to DROP for INPUT chain (设置INPUT链的默认行为为DROP)
iptables -L -n -v --line-numers # list all rules -L: --list; -n: --numberic(port number); -v --verbose;
iptables -Z # clear/reset packages count
iptables -Z INPUT # clear special chain packages count
iptables -D INPUT 5 # delete rule at posistion 5 in INPUT chain
iptables -I INPUT 2 -s 192.168.3.3 -j DROP # insert a rule before 2 (between 1 and 2) in INPUT chain

# iptables drop input for external tcp vistor to special port 为指定的端口拒绝外部的TCP包 (关闭指定端口)
# (-A: --append; -i: --in-interface; -p --protocol; --dport: destination-port)
iptables -A INPUT ! -i lo -p tcp --dport 8080 -j DROP # `! -i lo`: exclude loopback 出去本地环回

# iptables drop packages from some ip address (-s: --source)
iptables -A INPUT -s 3.4.5.6 -j DROP
iptables -A INPUT -s 192.168.0.0/24 -j DROP

# iptables log
iptables -A OUTPUT ! -i lo -p tcp -j LOG --log-prefix "iptable output log: "

# limit rule frequency (example: prevent flooding log) 限制频率,例如防止日志太多
# -m: --match (use extension for match) 使用扩展来测试是否匹配
iptables -A INPUT -p tcp -m limit --limit 5/second -j LOG
iptables -A INPUT -p tcp --dport 8080 -m limit ! --limit 5/second -j REJECT # limit visit frequency to 5/sec

# open port for special ip address range
iptables -A INPUT -p tcp --dport 80 -m iprange --src-range 192.168.1.1-192.168.1.100 -j ACCEPT

# save iptables rules to run at startup(boot time) 保存iptables的规则并且每次开机都执行
sudo apt install iptables-persistent
sudo su -c 'iptables-save > /etc/iptables/rules.v4' # or 'ip6tables-save > /etc/iptables/rules.v6'


# nftables (from Linux kernel 3.13)
# nftables is a netfilter project aims to replace the existing {ip,ip6,arp,eb}tables framework.
# nftables是新的数据包过滤框架(用于取代iptables系列框架)
# WIKI: https://wiki.nftables.org/wiki-nftables/index.php/Main_Page

# detect your kernel have `nf_tables` module (检测内核是否安装nf_tables)
modinfo nf_tables

# install (安装)
sudo apt install nftables

# and disable iptables (禁用iptables)
iptables -F
ip6tables -F

# basic command syntax 命令基本语法
nft <command> <subcommand> <chain> <rule definition>
# command: add, list, insert, delete, flush
# subcommand: table, chain, rule, ruleset
# table types: inet(=ip+ip6), ip, ip6, arp, bridge
# hooks: prerouting, input, forward, output, postrouting

# Netfilter hooks represent:
#                                   Local process  .-----------.
#                 .----------.           ^  |      |  Routing  |
#                 |          |--> input /    \---> |  Decision |--> output \
# -> prerouting ->| Routing  |                     .-----------.            \
#                 | Decision |                                               ---> postrouting
#                 |          |------------> forward ------------------------/
#                 .----------.

sudo nft list ruleset # list all tables/rules
sudo nft flush ruleset # delete/wipe all tables/rules
sudo nft flush ruleset ip # delete all rules only in ipv4 tables

# add -nn for list: show real port number and address ip but not name (显示真实的端口号和IP,而不是名字)
# add -a for list: show insert handle number (显示可以用于insert操作的序号)
sudo nft list ruleset -nn -a
sudo nft insert rule tableName chainName position 8 ip daddr 127.0.0.12 drop
# you can get position number (here is 8) by `list ruleset -a`

sudo nft -f firewall.nft # use rules from file

# example firewall.nft content:
table inet myTable { # inet is type combined ipv4 and ipv6 (在nftables中inet是ipv4和ipv6的合体)
	chain myChainForInput {
		type filter hook input priority 0;  # this chain is hook to input (这条链绑在input上)
		policy accept; # accept by default
		iif lo accept;
		# allow LOOPBACK(127.0.0.1 本地环回) input (iif: input interface index)

		tcp dport {8081, 8080} log prefix "nftables drop: " drop;
		# log and drop tcp packages to 8081 and 8080 (dport: destination port)
		# 记录并默默丢弃访问8081和8080的tcp数据包
		# you can find log in `journalctl -f` 在journalctl 中能找到对应的日志
		# and you can set log level likes: `log level warn` (emerg, alert, crit, err, warn, notice, info, debug)
	}
	chain testChain2 {
		type filter hook input priority 0;
		tcp dport >= 8000 ct state new limit rate over 10/second reject;
		# reject packages to port greater than equals 8000 when rate more than 10 per second
		# 对于发往8000以上的端口的数据包, 当大约每秒10个的限制后, 拒绝掉
		# ct state (State Of The Connection) Available: new, established, related, untracked
		# limit rate Examples: limit rate 5/day; limit rate over 5/second
	}
}

# save current rules to default. auto reload at boot time(保存目前的所有规则, 开机启用)
sudo nft list ruleset > /etc/nftables.conf # nftables.service load /etc/nftables.conf at boot time
