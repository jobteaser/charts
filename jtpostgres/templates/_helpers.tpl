{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "postgres.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "postgres.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Initialize data into the Postgresql database if it is not present.
*/}}
{{ define "postgres.initData" }}
- sh
- "-c"
- |
  set -ex
  # Exit if data is already persisted
  [[ -d /data/postgres ]] && exit 0
  # Download datafile from the object storage provider
  mc config host add $OS_PROVIDER $OS_HOST $OS_ACCESS_KEY_ID $OS_SECRET_ACCESS_KEY
  mc cp $OS_PROVIDER/$OS_BUCKET/{{ .Values.initData.datafile }} .
  # Untar mysql data into data persistence volume
  tar -C /data --strip-components=1 -xvf {{ .Values.initData.datafile }} data
  # Remove useless archive
  rm {{ .Values.initData.datafile }}
{{- end }}
