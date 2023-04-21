#!/bin/sh

PRODUCT='NAKIVO Backup & Replication'

#URL="http://10.10.18.187:8080/NBR/linux/10.8.0/NAKIVO_Transporter_Installer_10.8.0.73174.sh"
#SHA256="fdf1cb4601bc117078460bde07231da932ff37b3aa668e812d16d832d6810bed"

URL="http://10.10.18.187:8080/NBR/transporter/NAKIVO_Transporter_Installer-10.9.0.r73817-x86_64.sh"
SHA256="3f3ba6cd07900a1af98efc7d2f633264cac3f4fde4d3a220427f330eb4d4d6b7"


PRODUCT_ROOT="/usr/local/nakivo"
INSTALL="inst.sh"

curl --fail --tlsv1.2 -o $INSTALL $URL
if [ $? -ne 0 -o ! -e $INSTALL ]; then
    echo "ERROR: Failed to get $PRODUCT installer"
    rm $INSTALL >/dev/null 2>&1
    exit 1
fi

CHECKSUM=`sha256 -q $INSTALL`
if [ "$SHA256" != "$CHECKSUM" ]; then
    echo "ERROR: Incorrect $PRODUCT installer checksum"
    rm $INSTALL >/dev/null 2>&1
    exit 2
fi

sh ./$INSTALL -s -i "$PRODUCT_ROOT" --eula-accept 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR: $PRODUCT install failed"
    rm $INSTALL >/dev/null 2>&1
    exit 3
fi
rm $INSTALL >/dev/null 2>&1

exit 0
