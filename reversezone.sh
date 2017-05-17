#!/bin/bash
find /var/named/*.db | while read ZONES
do
replace "ns1.futuresouls.com" "webs01.futuresouls.com" -- $ZONES
replace "ns2.futuresouls.com" "webs02.futuresouls.com" -- $ZONES
A=`grep "ns3.futuresouls.com" $ZONES`
B=`grep "ns4.futuresouls.com" $ZONES`
sed -i '/'"$A"'/d' $ZONES
sed -i '/'"$B"'/d' $ZONES
done
