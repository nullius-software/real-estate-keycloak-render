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
ARG HOSTNAME
ARG HOSTNAME_ADMIN
# set port 8443 to PORT environment variable in render
#ENV KC_HTTP_RELATIVE_PATH=/auth
ENV PROXY_ADDRESS_FORWARDING=true
ENV KC_DB_USERNAME=$DB_USERNAME
ENV KC_DB_PASSWORD=$DB_PASSWORD
ENV KC_HOSTNAME_STRICT=false
ENV KC_HOSTNAME=$HOSTNAME
ENV KC_HOSTNAME_ADMIN=$HOSTNAME_ADMIN
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
ENV KC_DB_URL='postgres://postgres:${DB_PASSWORD}@${DB_URL}/${DB_DATABASE}'

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
ARG HOSTNAME
ARG HOSTNAME_ADMIN

# set port 8443 to PORT environment variable in render
#ENV KC_HTTP_RELATIVE_PATH=/auth
ENV PROXY_ADDRESS_FORWARDING=true
ENV KC_DB_USERNAME=$DB_USERNAME
ENV KC_DB_PASSWORD=$DB_PASSWORD
ENV KC_HOSTNAME_STRICT=false
ENV KC_HOSTNAME=$HOSTNAME
ENV KC_HOSTNAME_ADMIN=$HOSTNAME_ADMIN
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
ENV KC_DB_URL='postgres://postgres:${DB_PASSWORD}@${DB_URL}/${DB_DATABASE}'

EXPOSE 8443
EXPOSE 8444

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
# even though we build, using --optimized disallows postgresql databases so we need this workaround https://github.com/keycloak/keycloak/issues/15898
# in other words don't add optimzied here
CMD ["start", "--db=postgres", "-Dquarkus.datasource.jdbc.acquisition-timeout=60s"]