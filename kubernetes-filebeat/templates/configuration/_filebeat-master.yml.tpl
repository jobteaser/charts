{{- define "conf_master" }}
output:
{{ toYaml .Values.output | indent 2 }}

logging:
  to_files: false
  level: {{ .Values.loglevel }}
  metrics.enabled: false

processors:
  - add_cloud_metadata:
  - add_kubernetes_metadata:
      in_cluster: true
      annotations.dedot: true
      labels.dedot: true

filebeat.inputs:
  - type: docker
    containers.ids: '*'
    cri.parse_flags: true

  # apiserver
  - type: log
    enabled: true
    paths:
      - /var/log/kube-apiserver.log
    exclude_lines: ['^I']
    fields:
      kubernetes.role: master
      kubernetes.component: apiserver
    fields_under_root: true
    multiline.pattern: '^([IWE]|Trace)'
    multiline.negate: true
    multiline.match: after

  # scheduler
  - type: log
    enabled: true
    paths:
      - /var/log/kube-scheduler.log
    exclude_lines: ['^I']
    fields:
      kubernetes.role: master
      kubernetes.component: scheduler
    fields_under_root: true

  # controller-manager
  - type: log
    enabled: true
    paths:
      - /var/log/kube-controller-manager.log
    exclude_lines: ['^I']
    fields:
      kubernetes.role: master
      kubernetes.component: controller-manager
    fields_under_root: true

    multiline.pattern: '^[\t ]'
    multiline.negate: false
    multiline.match: after

  # etcd
  - type: log
    enabled: true
    paths:
      - /var/log/etcd.log
    fields:
      kubernetes.role: master
      kubernetes.component: etcd
    fields_under_root: true

{{- end }}
