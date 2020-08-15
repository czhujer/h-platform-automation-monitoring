# h-platform-automation-monitoring
monitoring stack for platform automation

based on centOS 7 and puppet (5.5)

## components

### nginx
frontend proxy
#### endpoints
- / for grafana
- /prometheus for prometheus

### grafana
https://github.com/grafana/grafana/

### prometheus
https://github.com/prometheus/prometheus/

jaeger/tracing added in MR (https://github.com/prometheus/prometheus/pull/7148)

configuration probably onle over ENV vars (https://github.com/jaegertracing/jaeger-client-go#environment-variables)


### blackbox-exporter
https://github.com/prometheus/blackbox_exporter

## loging
filebeats

## tracing
jaeger-agent in docker container

### docs
- https://www.jaegertracing.io/docs/1.18/architecture
- https://github.com/jaegertracing/jaeger-client-cpp
- https://github.com/opentracing-contrib/nginx-opentracing
- https://github.com/opentracing/opentracing-cpp/releases
