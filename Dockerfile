FROM erlang:20-alpine as build
MAINTAINER Petr Gotthard <petr.gotthard@centrum.cz>

RUN apk add --no-cache --virtual build-deps git make wget nodejs-npm

WORKDIR /src

COPY . ./

RUN make release install

FROM erlang:20-alpine

# volume for the mnesia database and logs
RUN mkdir /storage
VOLUME /storage

COPY --from=build /usr/lib/lorawan-server/ /usr/lib/lorawan-server/

# data from port_forwarders
EXPOSE 1680/udp
# http admin interface
EXPOSE 8080/tcp
# https admin interface
EXPOSE 8443/tcp

ENV LORAWAN_HOME=/storage
WORKDIR /usr/lib/lorawan-server
RUN chmod +x bin/lorawan-server
CMD bin/lorawan-server
