# stage: 1
FROM node:latest as react-build

# Create app directory
WORKDIR /app

COPY . ./

RUN yarn install
RUN yarn build

# stage: 2 — the production environment
FROM nginx:alpine
COPY --from=react-build /app/build /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf
RUN rm -f /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
# To provide a http authentication comment out the next two lines
#COPY conf/default.conf /etc/nginx/conf.d/default.conf
#COPY conf/authnginx/htpasswd /etc/nginx/authnginx/htpasswd
EXPOSE 80 
CMD ["nginx", "-g", "daemon off;"]
