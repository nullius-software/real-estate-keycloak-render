FROM quay.io/keycloak/keycloak:26.1.2 AS builder

ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_DB=postgres

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:26.1.2
COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak

ENV KC_DB_URL="jdbc:postgresql://ep-fragrant-king-a5pr6l3i-pooler.us-east-2.aws.neon.tech/db_real_estate_keycloack?sslmode=require"
ENV KC_DB_USERNAME=neondb_owner
ENV KC_DB_PASSWORD=npg_P6XhpCV2RANe
ENV KC_HOSTNAME=real-estate-keycloak-render.onrender.com
ENV KC_HTTP_PORT=8080
ENV KC_HTTPS_PORT=8443
ENV KC_PROXY=edge
ENV KEYCLOAK_ADMIN=admin
ENV KEYCLOAK_ADMIN_PASSWORD=admin
EXPOSE 8080
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized", "--http-host=0.0.0.0", "--spi-connections-jgroups-udp-enabled=false"]
