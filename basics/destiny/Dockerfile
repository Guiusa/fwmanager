FROM debian

RUN apt update \
    && apt install -y vim iproute2 net-tools host iputils-ping tcpdump

ENTRYPOINT ip route del default && ip route add default via 10.9.0.5 && tail -f /dev/null
