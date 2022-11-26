FROM alpine:3.10

RUN apk update \
    && apk add iptables ppp pptpd \
    && rm -rf /var/cache/apk/*

COPY ./pptpd/pptpd.conf /etc/pptpd.conf
COPY ./pptpd/pptpd-options /etc/ppp/pptpd-options
COPY ./pptpd/chap-secrets /etc/ppp/chap-secrets

EXPOSE 1723

ENV ENV_GATEWAY_INTERFACE "enp0s3"

CMD iptables -t nat -A POSTROUTING -o $ENV_GATEWAY_INTERFACE -j MASQUERADE \
    && iptables -A FORWARD -o $ENV_GATEWAY_INTERFACE -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 1356 \
    && iptables -A INPUT -i ppp+ -j ACCEPT \
    && iptables -A OUTPUT -o ppp+ -j ACCEPT \
    && iptables -A FORWARD -i ppp+ -j ACCEPT \
    && iptables -A FORWARD -o ppp+ -j ACCEPT \
    && pptpd \
    && syslogd -n -O /dev/stdout