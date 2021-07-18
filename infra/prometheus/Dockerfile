FROM prom/prometheus:latest
COPY ./prometheus.yml /etc/prometheus/
RUN ["gem", "install", "fluent-plugin-elasticsearch", "--no-document", "--version", "4.3.3"]
USER fluent
