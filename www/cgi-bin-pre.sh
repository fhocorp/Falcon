#!/bin/sh
_uptime=$(uptime)
_loadavg=${_uptime#*load average: }
_uptime=${_uptime#*up }
_uptime=${_uptime%%,*}
_hostname=$(cat /proc/sys/kernel/hostname)
_version=$(cat /etc/version)
_connexion3g=$(/sbin/ifconfig 3g-mobile | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')
echo Content-type: text/html
echo

cat<<EOF
<HTML>
<HEAD>
<TITLE>$(n=$(uname -n);echo ${n:-Freifunk.Net}) - $TITLE</TITLE>
<META CONTENT="text/html; charset=iso-8859-1" HTTP-EQUIV="Content-Type">
<META CONTENT="no-cache" HTTP-EQUIV="cache-control">
<LINK HREF="ff.css" REL="StyleSheet" TYPE="text/css">
<LINK HREF="sven-ola*ät*gmx*de" REV="made" TITLE="Sven-Ola">
<STYLE TYPE="text/css">
$(if ! grep -q '^LoadPlugin "olsrd_nameservice.so' /etc/olsrd.conf 2>&-;then echo '.plugin-services {display:none}';echo '.plugin-map {display:none}';elif test -z "`nvram get ff_adm_latlon`";then echo '.plugin-map {display:none}';fi)
</STYLE>
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
<SPAN CLASS="color"><A CLASS="color" HREF="cgi-bin-index.html">Accueil</A></SPAN><IMG ALT="" HEIGHT="10" HSPACE="2" SRC="images/vertbar.gif" WIDTH="1"><SPAN CLASS="color"><A CLASS="color" HREF="cgi-bin-admin.html">Administration</A></SPAN>
</div>
<div id="header">
        <div id="logo"><img src="images/logo.png" /></div>
	<div id="polaris-title"><h1>Console d'administration</h1></div>
	<div id="polaris-title2"><h1>du R&eacute;seau Polaris</h1></div>
	<div id="short-status">
		<ul>
			<li><strong>Host Name:</strong> $_hostname</li>
			<li><strong>Uptime:</strong> $_uptime</li>
			<li><strong>Adresse IP:</strong> $_connexion3g</li>
			<li><strong>Version:</strong> $_version</li>
		</ul>
	</div>
</div>
<div id="submenu">
</div>
<div>
<div id="sidebar_left">
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="7" WIDTH="150">
<TR>
<TD><BIG CLASS="plugin">Contenu</BIG></TD>
</TR>
EOF

for inc in /www/[0-9][0-9]-*;do test -n "${inc##*.sh}" && cat $inc ||. $inc;done

cat<<EOF
</TABLE></TD>
</div>
<TD VALIGN="top" WIDTH="5"></TD>
<TD VALIGN="top">
<div id="main">
EOF
