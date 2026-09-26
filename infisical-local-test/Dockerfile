FROM infisical/infisical:v0.165.16

USER root
COPY patch-entitlements.cjs patch-telemetry.cjs /tmp/
RUN node /tmp/patch-entitlements.cjs \
    && node /tmp/patch-telemetry.cjs \
    && rm /tmp/patch-entitlements.cjs /tmp/patch-telemetry.cjs
USER 1001
