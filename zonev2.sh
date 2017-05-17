#!/bin/bash
##ZONE EDITING SCRIPT
###DATE 18-APRIL-2017
####WEBSOULS TECHINAL SUPPORT TEAM





#cp -rf /var/named /var/named.backup
#echo " Backup taken of named directory "
SERIAL=$(date +%Y%m%d%M)
DATE=`date +%D-%H:%M:%S`
NAMESERVER1="ns1.futuresouls.com."
NAMESERVER2="ns2.futuresouls.com."
NAMESERVER3="ns3.futuresouls.com."
NAMESERVER4="ns4.futuresouls.com."
#find /var/named/*.db | grep -v test.websouls.net.db | grep -v test.itinurdu.com.db | grep -v fb.livesport99.com.db | while read ZONES
find /var/named/*.db | while read ZONES
do
NAMESERVERS=('ns1.futuresouls.com' 'ns2.futuresouls.com' 'ns3.futuresouls.com' 'ns4.futuresouls.com');
echo "reading zone $(tput setaf 2) $ZONES $(tput sgr0)"
for i in "${NAMESERVERS[@]}"
do
case $i in
ns1.futuresouls.com)
        grep -qF $i $ZONES
                if [[ $? == 0 ]] ; then
                echo "$(tput  setaf 1)FOUND $i $(tput sgr0)"
                echo "$DATE:FOUND:$i already at $ZONES " >> zone.log
                else
                NS1=`cat $ZONES | grep "NS" | sed -n "1p" | awk '{print $5}'`
                echo "$DATE:NOT FOUND:$i: Amending $ZONES" >> zone.log
                echo "$(tput setaf 2) NOT FOUND $i $(tput sgr0)"
                replace "$NS1" "$NAMESERVER1" -- $ZONES
                fi
;;
ns2.futuresouls.com)
        grep -qF $i $ZONES
                if [[ $? == 0 ]] ; then
                echo "$(tput  setaf 1)FOUND $i $(tput sgr0)"
                echo "$DATE:FOUND:$i already at $ZONES " >> zone.log
                else
                echo "$DATE:NOT FOUND:$i: Amending $ZONES" >> zone.log
                echo "$(tput setaf 2) NOT FOUND $i $(tput sgr0)"
                NS2=`cat $ZONES | grep "NS" | sed -n "2p" | awk '{print $5}'`
                replace "$NS2" "$NAMESERVER2" -- $ZONES
                fi
;;
ns3.futuresouls.com)
        grep -qF $i $ZONES
                if [[ $? == 0 ]] ; then
                echo "$(tput setaf 1)FOUND $i $(tput sgr0)"
                echo "$DATE:FOUND:$i already at $ZONES" >> zone.log
                else
                echo "$(tput setaf 2)NOT FOUND $i $(tput sgr0)"
                echo "$DATE:NOT FOUND:$i: Amending $ZONES" >> zone.log
                C=`grep $NAMESERVER2 $ZONES`
                DOMAIN=`grep "NS" $ZONES |sed -n "1p"  | awk '{print $1}'`
                A=`echo "$DOMAIN 86400 IN NS $NAMESERVER3"`
                sed -i '/'"$C"'/a '"$A"'' $ZONES
                fi
;;
ns4.futuresouls.com)
        grep -qF $i $ZONES
                if [[ $? == 0 ]] ; then
                echo "$(tput setaf 1)FOUND $i $(tput sgr0)"
                echo "$DATE:FOUND:$i already at $ZONES" >> zone.log
                else
                echo "$(tput setaf 2)NOT FOUND $i $(tput sgr0)"
                echo "$DATE:NOT FOUND:$i: Amending $ZONES" >> zone.log
                DOMAIN=`grep "NS" $ZONES | sed -n "1p" | awk '{print $1}'`
                C=`grep $NAMESERVER3 $ZONES`
                B=`echo "$DOMAIN 86400 IN NS $NAMESERVER4"`
                sed -i '/'"$C"'/a '"$B"'' $ZONES
                fi
;;
*)
        echo "Not a Valid nameserver"

esac
done
cat $ZONES | grep NS | grep -v ns1.futuresouls.com | grep -v ns2.futuresouls.com | grep -v ns3.futuresouls.com | grep -v ns4.futuresouls.com | while read lines
                                        do
                                                if [[ "$lines" ==  null ]] ; then
                                                echo "No Extra entries"
                                                else
                                                EXTRANSENTRY=`echo $lines | awk '{print $5}'`
                                                echo "$DATE:FOUND:$EXTRANSENTRY in $ZONES" >> zone.log
                                                echo "$(tput setaf 1)$EXTRANSENTRY DETECTED $(tput sgr0)"
                                                echo "$DATE:DELETING EXTRA NS ENTRY FROM $ZONES" >> zone.log
                                                echo "$(tput setaf 2)DELETING $EXTRANSENTRY FROM $ZONES $(tput sgr0)"
                                                D=`echo $lines`
                                                sed -i '/'"$D"'/d' $ZONES
                                                fi
                                        done
        OLDSERIAL=`grep -i  "serial" $ZONES | sed -n "1p" |  awk '{print $1}'`
        echo "$(tput setaf 2) Amending Serial $(tput sgr0)"
        replace "$OLDSERIAL" "$SERIAL" -- $ZONES
        grep -qF $OLDSERIAL $ZONES
                if [[ $? == 0 ]]; then
        echo "$(tput setaf 1)SERIAL NOT UPDATED$(tput sgr0)"
        echo "$(tput setaf 2)Attempting to Update...$(tput sgr0)"
        OLDSERIAL=$((OLDSERIAL + 1))
        echo "$(tput setaf 2)Applying NEW SERIAL = $OLDSERIAL $(tput sgr0)"
        replace "$OLDSERIAL" "UPDATEDSERIAL" -- $ZONES
        echo "$(tput setaf 2)DONE$(tput sgr0)"
                else
        echo "$(tput setaf 2)SERIAL UPDATED$(tput sgr0)"
        echo "$DATE:$i:SERIAL UPDATED" >> zone.log
                fi
done
