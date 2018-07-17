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
  # Download datafile from the object storage provider
  set +ex # Remove logging to avoid credentials leaking
  mc config host add $OS_PROVIDER $OS_HOST $OS_ACCESS_KEY_ID $OS_SECRET_ACCESS_KEY --api S3v4
  set -ex
  mc cp $OS_PROVIDER/$OS_BUCKET/{{ .Values.initData.datafile }} .
  # Untar mysql data into data persistence volume
  tar -C /data --strip-components=1 -xvf {{ .Values.initData.datafile }} mysql
  # Remove useless archive
  rm {{ .Values.initData.datafile }}
{{- end }}
