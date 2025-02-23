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
ENV KC_DB_USERNAME=""
ENV KC_DB_PASSWORD=""
ENV KC_HOSTNAME=localhost
ENV KC_HTTP_ENABLED=true
ENV KEYCLOAK_ADMIN=admin
ENV KEYCLOAK_ADMIN_PASSWORD=admin
EXPOSE 8080
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]