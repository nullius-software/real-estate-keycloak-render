#FROM quay.io/keycloak/keycloak:26.1.2 AS builder
#
#ENV KC_HEALTH_ENABLED=true
#ENV KC_METRICS_ENABLED=true
#ENV KC_DB=postgres
#ENV KC_SPI_CONNECTIONS_JGROUPS_UDP_ENABLED=false
#
#WORKDIR /opt/keycloak
#RUN /opt/keycloak/bin/kc.sh build
#
#FROM quay.io/keycloak/keycloak:26.1.2
#COPY --from=builder /opt/keycloak/ /opt/keycloak/
#WORKDIR /opt/keycloak
#
#ENV KC_DB_URL="jdbc:postgresql://ep-fragrant-king-a5pr6l3i-pooler.us-east-2.aws.neon.tech/db_real_estate_keycloack?sslmode=require"
#ENV KC_DB_USERNAME=neondb_owner
#ENV KC_DB_PASSWORD=npg_P6XhpCV2RANe
#ENV KC_HTTP_PORT=8080
#ENV KC_HTTPS_PORT=8443
#ENV KC_HTTP_ENABLED=true
#ENV KEYCLOAK_ADMIN=admin
#ENV KEYCLOAK_ADMIN_PASSWORD=admin
#EXPOSE 8080
#ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
#CMD ["start", "--optimized", "--http-host=0.0.0.0", "--hostname=https://real-estate-keycloak-render.onrender.com", "--proxy-headers=forwarded", "-Dquarkus.datasource.jdbc.acquisition-timeout=60s", "--cache=local"]

#####################################################################

#FROM quay.io/keycloak/keycloak:latest
#
#COPY server.crt /opt/keycloak/conf/server.crt
#COPY server.key /opt/keycloak/conf/server.key
#
#EXPOSE 8080
#
#CMD ["start", "--optimized"]

#####################################################################

#FROM quay.io/keycloak/keycloak:26.1.2 AS builder
#
#ENV KC_HEALTH_ENABLED=true
#ENV KC_METRICS_ENABLED=true
#ENV KC_DB=postgres
#
#WORKDIR /opt/keycloak
#RUN /opt/keycloak/bin/kc.sh build
#
#FROM quay.io/keycloak/keycloak:26.1.2
#COPY --from=builder /opt/keycloak/ /opt/keycloak/
#WORKDIR /opt/keycloak
#
#ENV KC_HTTPS_PORT=8080
#
#ENV KC_DB_URL="jdbc:postgresql://ep-fragrant-king-a5pr6l3i-pooler.us-east-2.aws.neon.tech/db_real_estate_keycloack?sslmode=require"
#ENV KC_DB_USERNAME=neondb_owner
#ENV KC_DB_PASSWORD=npg_P6XhpCV2RANe
#
#COPY server.crt /opt/keycloak/conf/server.crt
#COPY server.key /opt/keycloak/conf/server.key
#
#EXPOSE 8080
#ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
##CMD ["start", "--optimized", "--https-port=8080", "--hostname=real-estate-keycloak-render.onrender.com", "--https-certificate-file=/opt/keycloak/conf/server.crt", "--https-certificate-key-file=/opt/keycloak/conf/server.key", "--proxy-headers=forwarded", "--cache=local", "-Dquarkus.datasource.jdbc.acquisition-timeout=60s"]
#CMD ["start", "--optimized", "--https-port=8080", "--hostname=localhost", "--https-certificate-file=/opt/keycloak/conf/server.crt", "--https-certificate-key-file=/opt/keycloak/conf/server.key", "--proxy-headers=forwarded", "--cache=local"]

#############################################################################

FROM quay.io/keycloak/keycloak:latest as builder

# necessary to let us use postgresql
ENV OPERATOR_KEYCLOAK_IMAGE=quay.io/keycloak/keycloak:latest

# set these env variables
ARG ADMIN
ARG ADMIN_PASSWORD

# set these env variables, from db website
ARG DB_USERNAME
ARG DB_PASSWORD
ARG DB_URL
ARG DB_DATABASE

# set port 8443 to PORT environment variable in render
ENV KC_HTTP_RELATIVE_PATH=/auth
ENV PROXY_ADDRESS_FORWARDING=true
ENV KC_DB_USERNAME=$DB_USERNAME
ENV KC_DB_PASSWORD=$DB_PASSWORD
ENV KC_DB_URL_PROPERTIES='?sslmode=require'
ENV KC_HOSTNAME_STRICT=false
ENV KC_HOSTNAME=real-estate-keycloak-render.onrender.com
ENV KC_HOSTNAME_ADMIN=https://real-estate-keycloak-render.onrender.com
ENV KC_HTTP_ENABLED=true
ENV KC_HTTP_PORT=8443
ENV KC_HTTPS_PORT=8444
ENV KC_LOG_LEVEL=INFO
ENV KC_HOSTNAME_STRICT_HTTPS=false
ENV KC_PROXY=passthrough
ENV KC_PROXY_HEADERS=xforwarded
ENV KEYCLOAK_ADMIN=$ADMIN
ENV KEYCLOAK_ADMIN_PASSWORD=$ADMIN_PASSWORD
ENV KB_DB=postgres
ENV KC_DB_URL=jdbc:postgresql://${DB_URL}/${DB_DATABASE}

# db may seem redundant but it is not
RUN /opt/keycloak/bin/kc.sh build --db=postgres
FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# necessary to let us use postgresql
ENV OPERATOR_KEYCLOAK_IMAGE=quay.io/keycloak/keycloak:latest

# set these env variables
ARG ADMIN
ARG ADMIN_PASSWORD

# set these env variables, from db website
ARG DB_USERNAME
ARG DB_PASSWORD
ARG DB_URL
ARG DB_DATABASE
ARG DB_SCHEMA

# set port 8443 to PORT environment variable in render
ENV KC_HTTP_RELATIVE_PATH=/auth
ENV PROXY_ADDRESS_FORWARDING=true
ENV KC_DB_USERNAME=$DB_USERNAME
ENV KC_DB_PASSWORD=$DB_PASSWORD
ENV KC_DB_URL_PROPERTIES='?'
ENV KC_HOSTNAME_STRICT=false
ENV KC_HOSTNAME=real-estate-keycloak-render.onrender.com
ENV KC_HOSTNAME_ADMIN=https://real-estate-keycloak-render.onrender.com
ENV KC_HTTP_ENABLED=true
ENV KC_HTTP_PORT=8443
ENV KC_HTTPS_PORT=8444
ENV KC_LOG_LEVEL=INFO
ENV KC_HOSTNAME_STRICT_HTTPS=false
ENV KC_PROXY=passthrough
ENV KC_PROXY_HEADERS=xforwarded
ENV KEYCLOAK_ADMIN=$ADMIN
ENV KEYCLOAK_ADMIN_PASSWORD=$ADMIN_PASSWORD
ENV KB_DB=postgres
ENV KC_DB_URL=jdbc:postgresql://${DB_URL}/${DB_DATABASE}

EXPOSE 8443
EXPOSE 8444

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
# even though we build, using --optimized disallows postgresql databases so we need this workaround https://github.com/keycloak/keycloak/issues/15898
# in other words don't add optimzied here
CMD ["start", "--db=postgres"]