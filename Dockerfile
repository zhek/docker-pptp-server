FROM alpine:3.10

RUN apk update \
    && apk add iptables ppp pptpd \
    && rm -rf /var/cache/apk/*

COPY ./pptpd/pptpd.conf /etc/pptpd.conf
COPY ./pptpd/pptpd-options /etc/ppp/pptpd-options
COPY ./pptpd/chap-secrets /etc/ppp/chap-secrets

EXPOSE 1723

CMD iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE \
    && iptables -A FORWARD -o eth0 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 1356 \
    && iptables -A INPUT -i ppp+ -j ACCEPT \
    && iptables -A OUTPUT -o ppp+ -j ACCEPT \
    && iptables -A FORWARD -i ppp+ -j ACCEPT \
    && iptables -A FORWARD -o ppp+ -j ACCEPT \
    && pptpd \
    && syslogd -n -O /dev/stdout