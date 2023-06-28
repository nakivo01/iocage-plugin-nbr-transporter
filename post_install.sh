#!/bin/sh

PRODUCT='NAKIVO Backup & Replication'

URL="http://10.10.18.187:8080/NBR/transporter/NAKIVO_Transporter_Installer-10.8.0.r74762-x86_64.sh"
SHA256="b80ea903c08039dbe40919c4a93a5d4c78a3f509192cd837ebe9b70041f3d20d"

#URL="http://10.10.18.187:8080/NBR/transporter/NAKIVO_Transporter_Installer-10.9.0.r75426-x86_64.sh"
#SHA256="14033b6319eaa6b71de7b96342281e9e081de940c115e2bd1d9af51e71ca08c8"


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
