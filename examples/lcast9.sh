#!/bin/sh

touch /tmp/BULB0
touch /tmp/BULB1

CC="TV";
KEY=$(echo "c4732c43f1a963fb05ae93b452d6467513dc31f908ba34d02ec7aa08f1bca62e:");
LIFX="https://api.lifx.com/v1/lights";

#colour
BULB0='d073d503aa58';
#white
BULB1='d073d511cf45';

while sleep 10;
do
(
BP0=$(cat /tmp/BULB0 | sed -n '1p');
BB0=$(cat /tmp/BULB0 | sed -n '2p');
BP1=$(cat /tmp/BULB1 | sed -n '1p');
BB1=$(cat /tmp/BULB1 | sed -n '2p');


lcaston()
{
curl -s -u "$KEY" -X PUT -d "power=$BP0&brightness=$BB0" "$LIFX/$BULB0/state";
curl -s -u "$KEY" -X PUT -d "power=$BP1" "$LIFX/$BULB1/state";
}

lcastoff()
{
curl -s -u "$KEY" -X PUT -d "brightness=0.33" "$LIFX/$BULB0/state";
curl -s -u "$KEY" -X PUT -d "power=off" "$LIFX/$BULB1/state";
}


lifxst()
{
curl -s -u "$KEY" "$LIFX/$BULB0" | egrep 'power|brightness' | cut -d':' -f 2 | sed 's/\"//g' | tr -d ','| tr -d ' ' > /tmp/BULB0
curl -s -u "$KEY" "$LIFX/$BULB1" | egrep 'power|brightness' | cut -d':' -f 2 | sed 's/\"//g' | tr -d ','| tr -d ' ' > /tmp/BULB1
}

CASTSTATUS=$(avahi-browse -rt _googlecast._tcp | grep $CC | grep txt | cut -d'"' -f 6 | cut -d'=' -f 2 | tail -n 1);
#TIME=$(date)
echo "$(tail -n 1 /tmp/caststatus)" > /tmp/caststatus;
echo $CASTSTATUS  >> /tmp/caststatus;
CHANGE=$(tail -n 2 /tmp/caststatus | tr '\n' ' ' | sed 's/ //')

if [ $CHANGE = "01" ];
then
lifxst && lcastoff
elif [ $CHANGE = "10" ];
then
lcaston
else
:
fi
#! END
);

done
