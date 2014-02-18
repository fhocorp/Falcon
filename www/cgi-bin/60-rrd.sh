#!/bin/sh
cat<<EOF
<TR><TD><BIG CLASS="plugin">Statistiques</BIG></TD></TR>
<TR><TD><DIV CLASS="plugin"><A CLASS="plugin" HREF="cgi-bin-rrd1.html?START=end-4h">Signal radio</A></DIV></TD></TR>
<TR><TD><DIV CLASS="plugin"><A CLASS="plugin" HREF="cgi-bin-rrd2.html?START=end-4h">Trafic de donn&eacute;es</A></DIV></TD></TR>
<TR><TD><DIV CLASS="plugin"><A CLASS="plugin" HREF="cgi-bin-rrd3.html?START=end-4h">Syst&egrave;me</A></DIV></TD></TR>
<TR><TD><DIV CLASS="plugin"><A CLASS="plugin" HREF="cgi-bin-rrd4.html?START=end-4h">OLSR$(grep -q N7 /var/rrd/olsr-neigh.dat 2>&- && echo ' (#1)')</A></DIV></TD></TR>
EOF
if grep -q N7 /var/rrd/olsr-neigh.dat 2>&-;then
cat<<EOF
<TR><TD><DIV CLASS="plugin"><A CLASS="plugin" HREF="cgi-bin-rrd5.html?START=end-4h">OLSR (#2)</A></DIV></TD></TR>
EOF
fi
