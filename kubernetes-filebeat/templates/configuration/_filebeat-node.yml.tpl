{{- define "conf_node" }}

processors:
  - add_cloud_metadata:
  - add_kubernetes_metadata:
      in_cluster: true

output:
{{ toYaml .Values.output | indent 2 }}

logging:
  to_files: false
  level: {{ .Values.loglevel }}
  metrics.enabled: false

filebeat.autodiscover:
  providers:

  - type: kubernetes
    labels.dedot: true
    annotations.dedot: true

    include_annotations:
    - log/format
    - log/multiline-pattern
    - log/multiline-negate
    - log/multiline-match
    templates:

    - condition:
        equals:
          kubernetes.annotations.log/format: json
      config:
      - type: docker
        containers.ids:
        - "${data.kubernetes.container.id}"
        json.keys_under_root: "true"
        json.message_key: msg
        fields:
          autodiscover.provider.name: kubernetes-json
        fields_under_root: true

    - condition:
        equals:
          kubernetes.annotations.log/format: multiline
      config:
      - type: docker
        containers.ids:
        - "${data.kubernetes.container.id}"
        fields:
          autodiscover.provider.name: kubernetes-multiline
        fields_under_root: true
        multiline.pattern: "${data.kubernetes.annotations.log/multiline-pattern}"
        multiline.negate: "${data.kubernetes.annotations.log/multiline-negate:false}"
        multiline.match: "${data.kubernetes.annotations.log/multiline-after:after}"

    - condition:
        and:
        - not.equals:
            kubernetes.annotations.log/format: json
        - not.equals:
            kubernetes.annotations.log/format: multiline
      config:
      - type: docker
        containers.ids:
        - "${data.kubernetes.container.id}"
        fields:
          autodiscover.provider.name: kubernetes-default
        fields_under_root: true

{{- end }}
