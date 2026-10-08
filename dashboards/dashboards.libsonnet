{
  grafanaDashboards+:: {
    'betterdb-instance-vitals.json': (import 'raw/betterdb-instance-vitals.json'),
    'betterdb-query-patterns.json': (import 'raw/betterdb-query-patterns.json'),
    'betterdb-cluster-slots.json': (import 'raw/betterdb-cluster-slots.json'),
    'betterdb-anomalies.json': (import 'raw/betterdb-anomalies.json'),
  },
}
