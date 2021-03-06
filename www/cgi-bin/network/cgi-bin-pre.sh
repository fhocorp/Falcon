#!/bin/sh
_uptime="$(uptime)"
_loadavg="${_uptime#*load average: }"
_uptime="${_uptime#*up }"
_uptime="${_uptime%%,*}"
_hostname=$(cat /proc/sys/kernel/hostname)
_version=$(cat /etc/version)
_connexion3g="$(/sbin/ifconfig 3g-mobile | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"
_connexionwan="$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')"
echo Content-type: text/html
echo

cat<<EOF
<HTML>
<HEAD><TITLE>$(n=$(uci get system.@system[0].hostname);echo ${n:-Falcon}) -
$TITLE</TITLE>
<META CONTENT="text/html; charset=iso-8859-1" HTTP-EQUIV="Content-Type">
<META CONTENT="no-cache" HTTP-EQUIV="cache-control">
<LINK HREF="/ff.css" REL="StyleSheet" TYPE="text/css">
<LINK HREF="sven-ola*�t*gmx*de" REV="made" TITLE="Sven-Ola">
EOF
unescape()
{
s=$(echo "$1"|sed -e"s/+/%20/g")
echo -n ${s%%%*}
if [ -n "$s" ] && [ "$s" != "${s#*%}" ];then
IFS=\%
set ${s#*%}
unset IFS
for i in "$@";do
echo -n -e "\\x$(echo $i|dd bs=1 count=2 2>&-)"
echo -n ${i#??}
done
fi
}
checkbridge()
{
ret=0
. /etc/functions.sh
dev=$(uci get network.hotspot.ifname)
if [ -z "$dev" ]; then
# 8Mb device may die in S15ffnvram, so correct
dev=$(l=$(grep : /proc/net/wireless);l=${l%:*};echo ${l##* })
if [ -n "$dev" ]; then
uci set network.hotspot.ifname=$dev
ret=1
fi
fi
if [ -n "$dev" ]; then
fnd=
old="$(uci get network.wan.ifname)"
for i in $old; do
test "$i" = "$dev" && fnd=1
done
wbr=
adr=$(nvram get wifi_ipaddr)
if [ -z "$adr" ] || [ "$adr" = "$(nvram get lan_ipaddr)" ];then
# WIFI dev should be in the bridge list
wbr=1
fi
if [ "$wbr" != "$fnd" ]; then
if [ -z "$wbr" ]; then
new=
for i in $old; do
test "$i" != "$dev" && new="$new $i"
done
new=${new# }
else
new="$old $dev"
fi
/usr/sbin/uci set network.lan.ifname="$new"
if [ -z "$(/usr/sbin/uci get network.lan.ifname)" ]; then
lan=$(uci get network.lan.ifname)
test -z "$lan" || lan=eth1
uci set network.lan.ifname=$lan
fi
ret=1
fi
fi
return $ret
}
cat<<EOF
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript"><!--
function help(e) {
if (!e) e = event;
// (virt)KeyVal is Konqueror, charCode is Moz/Firefox, else MSIE, Netscape, Opera
if (26 == e.virtKeyVal || !e.keyVal && !e.charCode && 112 == (e.which || e.keyCode)) {
var o = null;
if (e.preventDefault) {
if (e.cancelable) e.preventDefault();
o = e.target;
}
else {
e.cancelBubble = true;
o = e.srcElement;
}
while(o && '' == o.title) o = o.parentNode;
if (o) alert(o.title);
}
}
if (document.all) {
document.onkeydown = help;
document.onhelp = function(){return false;}
}
else {
document.onkeypress = help;
}
//--></SCRIPT>
</HEAD>
<BODY>
<div id="menu" class="color">
<SPAN CLASS="color"><A CLASS="color" HREF="/cgi-bin-index.html">Accueil</A></SPAN><IMG ALT="" HEIGHT="10" HSPACE="2" SRC="/images/vertbar.gif" WIDTH="1"><SPAN CLASS="color"><A CLASS="color" HREF="/cgi-bin/index.html">Administration</A></SPAN>
</div>
<div id="header">
        <div id="logo"><img src="../../images/logo2.png" /></div>
	<div id="polaris-title"><h1>Console d'administration</h1></div>
	<div id="polaris-title2"><h1></h1></div>
	<div id="short-status">
		<ul>
			<li><strong>Uptime:</strong> $_uptime</li>
			<li><strong>Charge syst&egrave;me:</strong> $_loadavg</li>
			<li><strong>Version:</strong> $_version</li>
			<li><strong>Adresse IP:</strong> $_connexion3g $_connexionwan</li>
		</ul>
	</div>
</div>
<div id="submenu">
<A HREF="/cgi-bin/network/index.html">Configuration R&eacute;seau</A><A HREF="/cgi-bin/services.html">Services</A><A HREF="/cgi-bin/system/index.html">Syst&egrave;me</A><A HREF="/cgi-bin/state/index.html">Etat</A><A HREF="/cgi-bin/reset.html">Red&eacute;marrage</A>
</div>
<div id="sidebar_left">
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="7" WIDTH="150">
EOF

for inc in [0-9][0-9]-*;do cat $inc;done

cat<<EOF
</TABLE>
</div>
<div id="main">
EOF
