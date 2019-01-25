{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "mysql.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "mysql.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Initialize data into the MySQL database if it is not present.
*/}}
{{ define "mysql.initData" }}
- sh
- "-c"
- |
  set -ex
  # Exit if data is already persisted
  [[ -d /data/mysql ]] && exit 0
  # Download datafile from the object storage provider and extract it
  aws s3 cp s3://$OS_BUCKET/{{ .Values.initData.datafile }} - | tar -C /data --strip-components=1 -xzvf - mysql
{{- end }}
