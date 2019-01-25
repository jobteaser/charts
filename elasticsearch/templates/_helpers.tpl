{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "elasticsearch.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Initialize data into the elasticsearch indices if it is not present.
*/}}
{{ define "elasticsearch.initData" }}
- sh
- "-c"
- |
  set -ex
  # Exit if data is already persisted
  [[ -d /data/elasticsearch ]] && exit 0
  # Download datafile from the object storage provider and untar elasticsearch data from it into data persistence volume
  aws s3 cp s3://$OS_BUCKET/{{ .Values.initData.datafile }} - | tar -C /data --strip-components=1 -xzvf - {{ .Values.initData.sourceDirectory }}
{{- end }}
