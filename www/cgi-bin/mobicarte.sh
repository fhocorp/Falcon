#!/bin/sh

echo "<BR> Ajout du profil MOBICARTE Orange <BR>"

uci set network.mobile.apn=orange
uci set network.mobile.username=orange
uci set network.mobile.password=orange
uci commit
killall pppd