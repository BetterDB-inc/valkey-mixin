{
  _config+:: {
    // Prometheus job that scrapes BetterDB Monitor's /prometheus/metrics
    // endpoint. Override when you scrape it under a different job name.
    betterdbSelector: 'job="betterdb"',

    // Alert thresholds. All are strings so they interpolate cleanly into
    // PromQL. Override any of them when vendoring this mixin.

    // Fire when used memory reaches this percent of maxmemory.
    memoryUsedPercent: '90',
    // Fire when the allocator fragmentation ratio exceeds this value.
    fragmentationRatio: '1.5',
    // Only evaluate fragmentation once the instance holds a real dataset;
    // the ratio is meaningless (and often very high) on near-empty instances.
    fragmentationMinUsedBytes: '1e8',
    // Range window for the eviction-rate alert.
    evictionWindow: '5m',
    // Fire when a replica is this many seconds behind its master.
    replicaLagSeconds: '30',
  },
}
