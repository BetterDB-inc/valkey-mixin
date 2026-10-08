{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'betterdb-monitor',
        rules: [
          // Availability
          {
            alert: 'BetterDBMonitorInstanceUnreachable',
            expr: 'betterdb_poll_stale{%(betterdbSelector)s} == 1' % $._config,
            'for': '5m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'BetterDB Monitor cannot reach a monitored instance.',
              description: 'BetterDB Monitor has had no successful poll of {{ $labels.connection }} within its staleness window. The instance is likely down or unreachable.',
            },
          },
          {
            alert: 'ValkeyReplicaLinkDown',
            expr: 'betterdb_master_link_up{%(betterdbSelector)s} == 0' % $._config,
            'for': '1m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'A replica has lost its link to the master.',
              description: 'Replica {{ $labels.connection }} has lost its link to the master. Replication is stalled.',
            },
          },
          {
            alert: 'ValkeyClusterSlotsFailing',
            expr: 'betterdb_cluster_slots_fail{%(betterdbSelector)s} > 0' % $._config,
            'for': '5m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'Cluster slots are in FAIL state.',
              description: '{{ $value }} cluster slots are in FAIL state on {{ $labels.connection }}. Part of the keyspace is unavailable.',
            },
          },
          // Resource saturation (USE)
          {
            alert: 'ValkeyMemoryNearMaxmemory',
            expr: 'betterdb_memory_used_bytes{%(betterdbSelector)s} / betterdb_memory_max_bytes{%(betterdbSelector)s} * 100 > %(memoryUsedPercent)s and betterdb_memory_max_bytes{%(betterdbSelector)s} > 0' % $._config,
            'for': '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'Memory use is approaching the maxmemory limit.',
              description: 'Memory use on {{ $labels.connection }} is {{ $value | printf "%.1f" }}% of maxmemory. Evictions or OOM command rejections are imminent.',
            },
          },
          {
            alert: 'ValkeyHighMemoryFragmentation',
            expr: 'betterdb_memory_fragmentation_ratio{%(betterdbSelector)s} > %(fragmentationRatio)s and betterdb_memory_used_bytes{%(betterdbSelector)s} > %(fragmentationMinUsedBytes)s' % $._config,
            'for': '15m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'Allocator memory fragmentation is high.',
              description: 'Memory fragmentation ratio on {{ $labels.connection }} is {{ $value | printf "%.2f" }}. RSS is well above the live dataset.',
            },
          },
          // Performance and errors (RED)
          {
            alert: 'ValkeyKeysBeingEvicted',
            // betterdb_evicted_keys_total is exposed with a gauge type but is a
            // cumulative counter sourced from INFO, so increase() is correct.
            expr: 'increase(betterdb_evicted_keys_total{%(betterdbSelector)s}[%(evictionWindow)s]) > 0' % $._config,
            labels: { severity: 'warning' },
            annotations: {
              summary: 'Keys are being evicted.',
              description: 'Keys are being evicted on {{ $labels.connection }} ({{ $value | printf "%.0f" }} in ' + $._config.evictionWindow + '). The instance is at its memory limit and dropping data.',
            },
          },
          {
            alert: 'ValkeyReplicaLagHigh',
            expr: 'betterdb_master_last_io_seconds_ago{%(betterdbSelector)s} > %(replicaLagSeconds)s' % $._config,
            'for': '1m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'A replica is falling behind its master.',
              description: 'Replica {{ $labels.connection }} last synced with its master {{ $value | printf "%.0f" }}s ago. Replication is falling behind.',
            },
          },
          // Info, security, and config
          {
            alert: 'ValkeyLastRDBSaveFailed',
            expr: 'betterdb_rdb_last_bgsave_ok{%(betterdbSelector)s} == 0' % $._config,
            'for': '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'The last RDB background save failed.',
              description: 'The last RDB background save failed on {{ $labels.connection }}. Persistence is stale and data may be lost on restart.',
            },
          },
        ],
      },
    ],
  },
}
