FROM nginx:1.19.10-alpine
COPY ./nginx.conf /etc/nginx/nginx.conf

VOLUME ["/var/www/html", "/var/log/nginx/"]

EXPOSE 80/TCP
EXPOSE 443/TCP
CMD ["nginx", "-g", "daemon off;"]