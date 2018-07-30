FROM fholzer/nginx-brotli

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx.vh.default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80 443

CMD /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf