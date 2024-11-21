FROM nginx:stable-alpine3.20

RUN apk update && apk add bash

COPY ./data/ /usr/share/nginx/ 
COPY ./nginx/ /etc/nginx/
COPY ./scripts/ /scripts/

RUN mkdir /var/log/nginx/custom && \
    touch /var/log/nginx/custom/4xx.log && \
    touch /var/log/nginx/custom/5xx.log && \
    touch /var/log/nginx/custom/custom-all.log && \
    chown -R nginx:nginx /var/log/nginx

CMD ["bash", "-c", "./scripts/set_nginx.sh && \
    nginx -g 'daemon off;' & \
    /scripts/cpu_usage.sh & \
    /scripts/log.sh & \
    tail -f /dev/null"]