#!/bin/sh

echo "<BR> Ajout du profil FORFAIT Orange <BR>"

uci set network.mobile.apn=orange.fr
uci set network.mobile.username=orange
uci set network.mobile.password=orange
uci commit
killall pppd