# Monitoring

The baseline monitoring stack is:

- Prometheus for metrics storage
- Node Exporter for host metrics
- cAdvisor for container metrics
- Grafana for dashboards

Sentinel should eventually consume these metrics and convert anomalies into Roderick alerts and Atlas explanations.
