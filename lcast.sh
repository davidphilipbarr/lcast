#!/bin/sh
KEY=$(echo "YOUR KEY");
LIFX="https://api.lifx.com/v1/lights";
CASTSTATUS=$(avahi-browse -rt _googlecast._tcp | grep txt | cut -d'"' -f 6 | cut -d'=' -f 2);
LFXS=$(cat /tmp/lifxstat | cut -d'|' -f 1);
BULB0='all';

echo "$CASTSTATUS"  >> ~/.caststatus;

CHANGE=$(tail -n 2 ~/.caststatus | tr '\n' ' ' | sed 's/ //')

lcaston()
{
curl -s -u "$KEY" -X PUT -d "power=$LFXS2" "$LIFX/$BULB0/state";
}

lcastoff()
{
curl -s -u "$KEY" -X PUT -d "power=off" "$LIFX/$BULB0/state";
}

lifxst()
{
LIFXSTATUS2=$(curl -s -u "$KEY" "$LIFX/$BULB0" | grep power | cut -d '"'  -f 4 | head -1);
echo "$LIFXSTATUS|$LIFXSTATUS2" > /tmp/lifxstat;
}

if [ $CHANGE = "01" ];
then
lifxst && lcastoff
elif [ $CHANGE = "10" ];
then 
lcaston
else 
echo "DOING NOTHING";
fi

