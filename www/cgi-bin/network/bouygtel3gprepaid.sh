#!/bin/sh

echo "<BR> Ajout du profil Bouygtel Prepaye <BR>"

uci set network.mobile.apn=vpnbouygtel.com
uci set network.mobile.username=
uci set network.mobile.password=
uci commit
killall pppd