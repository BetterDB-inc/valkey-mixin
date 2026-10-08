# BetterDB Monitor mixin (Valkey / Redis / Dragonfly)

Grafana dashboards and Prometheus alerts for Valkey, Redis, and Dragonfly,
built on the `betterdb_` metrics that [BetterDB Monitor](https://betterdb.com)
exposes at `/prometheus/metrics`. Packaged as a
[monitoring mixin](https://monitoring.mixins.dev/) so you can vendor it into
your own Prometheus and Grafana setup.

## What's inside

- `dashboards/` - four dashboards: Instance Vitals, Query Patterns, Cluster
  Slots, and Anomalies.
- `alerts/` - eight alerting rules covering availability, memory saturation,
  evictions, replication, and persistence.
- `config.libsonnet` - the scrape-job selector and the alert thresholds.
  Override any of them when you vendor the mixin.

## Generate the dashboards and alerts

```
jb install
mixtool generate all mixin.libsonnet
```

This writes `prometheus_alerts.yaml` and one JSON file per dashboard.

## Override the defaults

```jsonnet
local mixin = (import 'mixin.libsonnet') + {
  _config+:: {
    betterdbSelector: 'job="my-betterdb-job"',
    memoryUsedPercent: '85',
  },
};
```

## Before you start

Scrape BetterDB Monitor's metrics endpoint:

```yaml
scrape_configs:
  - job_name: betterdb
    metrics_path: /prometheus/metrics
    static_configs:
      - targets: ['betterdb-monitor:3001']
```

See https://docs.betterdb.com/prometheus-integration.

## Labels

BetterDB Monitor tags each instance with a `connection` label (host:port), not
the `instance` label the node and exporter mixins use. The dashboards and alerts
filter and group by `connection`. A few `mixtool lint` dashboard rules assume an
`instance` label and a single-target `job`, so they don't apply here. The alerts
pass `promtool check rules`.
