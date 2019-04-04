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
{{- if .Values.initData.restoreSnapshot.enabled }}
  aws s3 cp s3://$OS_BUCKET/{{ .Values.initData.datafile }} - | tar -C /snapshots --strip-components=1 -xzvf - {{ .Values.initData.restoreSnapshot.sourceDirectory }}
{{- else }}
  aws s3 cp s3://$OS_BUCKET/{{ .Values.initData.datafile }} - | tar -C /data --strip-components=1 -xzvf - {{ .Values.initData.sourceDirectory }}
{{- end }}
{{- end }}


{{/*
Initialize data into the elasticsearch indices if it is not present.
*/}}
{{ define "elasticsearch.restoreSnapshot" }}
- sh
- "-c"
- |
  set -ex
  # Exit if no snapshot is present
  [ -d /usr/share/elasticsearch/data/snapshots ] || exit 0
  # Download datafile from the object storage provider and untar elasticsearch data from it into data persistence volume
  /docker-entrypoint.sh elasticsearch -p /run/elasticsearch/es.pid -d --path.repo=/usr/share/elasticsearch/data/snapshots
  echo Waiting for ES to be up...
  while ! curl >/dev/null 2>&1 localhost:9200; do
    sleep 2
  done

  echo ES is up.
  sleep 2

  echo Restoring snasphot...
  curl -XPOST "localhost:9200/_all/_close?allow_no_indices=true&expand_wildcards=all&wait_for_completion=true"
  curl -XPUT "localhost:9200/_snapshot/{{ .Values.initData.restoreSnapshot.repository }}" -d '{"type": "fs", "settings": {"compress": "true", "location": "/usr/share/elasticsearch/data/snapshots"}}'
  curl -XPOST "localhost:9200/_snapshot/{{ .Values.initData.restoreSnapshot.repository }}/{{ .Values.initData.restoreSnapshot.name }}/_restore?wait_for_completion=true"
  curl -XPOST "localhost:9200/_all/_open?allow_no_indices=true&expand_wildcards=all&wait_for_completion=true"
  curl -XDELETE "localhost:9200/_snapshot/{{ .Values.initData.restoreSnapshot.repository }}/{{ .Values.initData.restoreSnapshot.name }}?wait_for_completion=true"
  curl -XDELETE "localhost:9200/_snapshot/{{ .Values.initData.restoreSnapshot.repository }}?wait_for_completion=true"
  kill -15 $(cat /run/elasticsearch/es.pid)

  echo Restore successful, removing snapshot.
  rm -rf /usr/share/elasticsearch/data/snapshots/*
{{- end }}
