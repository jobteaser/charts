{{- define "conf_master" }}
filebeat.config:
  modules:
    path: ${path.config}/modules.d/*.yml
    # Reload module configs as they change:
    reload.enabled: false
processors:
  - add_cloud_metadata:

output.elasticsearch:
  hosts: ['{{ .Values.app.elasticsearch_host }}']
  {{- if .Values.app.elastic_auth_enabled }}
  username: {{ .Values.app.elasticsearch_username }}
  password: {{ .Values.app.elasticsearch_password }}
  {{- end }}

filebeat.prospectors:
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
