{{- define "conf_node" }}
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

{{- end }}
