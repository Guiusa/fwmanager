#! /bin/bash

COUNT=100
RATE=100
VFLAG=1
while getopts "c:r::q" option; do
  case $option in
    c)
      COUNT=$OPTARG;;
    r)
      RATE=$OPTARG;;
    q)
      VFLAG=0;;
  esac
done

###############################################################################
[[ $VFLAG == 1 ]] && echo "starting capture packages on fw container..."

#docker exec -dit fw /root/run-tests/ping.sh $COUNT
docker exec -dit fw tcpdump \
	-i eth0 \
	-f "icmp[icmptype] == icmp-echo" \
	-c$COUNT \
	-w /root/run-tests/outfiles/pingorigin.pcap \
	-q \
	> /dev/null 2>&1 &

docker exec -dit fw tcpdump \
	-i eth1 \
	-f "icmp[icmptype] == icmp-echo" \
	-c$COUNT \
	-w /root/run-tests/outfiles/pingdestiny.pcap \
	-q \
	> /dev/null 2>&1 &

###############################################################################
sleep 1
[[ $VFLAG == 1 ]] && echo "starting process to generate packages on origin container..."
docker exec -dit origin \
nping \
  --icmp \
  --data-length 83 \
  --rate $RATE \
  --count $COUNT \
  10.9.0.6
###############################################################################
[[ $VFLAG == 1 ]] && echo -e "\e[0;31mWAITING...\e[0m"
[[ $((COUNT/RATE)) == 0 ]] && sleep 1
sleep $((COUNT/RATE))
