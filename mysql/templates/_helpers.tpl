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
{{- if .Values.initData.restoreSql.enabled }}
  aws s3 cp s3://$OS_BUCKET/{{ .Values.initData.restoreSql.sqlfile }} - | gunzip > /initdb/{{ .Values.initData.restoreSql.tableName }}.sql.gz
{{- else }}
  aws s3 cp s3://$OS_BUCKET/{{ .Values.initData.datafile }} - | tar -C /data --strip-components=1 -xzvf - mysql
{{- end }}
{{- end }}

{{/*
Initialize data into the elasticsearch indices if it is not present.
*/}}
{{ define "mysql.restoreSql" }}
- sh
- "-c"
- |
  set -e
  # Exit if no mysql dump is present
  [ -f /initdb/{{ .Values.initData.restoreSql.tableName }}.sql.gz ] || exit 0
  # Apply mysql dump
  docker-entrypoint.sh mysqld --wait_timeout=28800 --innodb_log_file_size=128M --max_allowed_packet=128M &
  pid="$!"
  echo Waiting for MySQL to be up...
  while ! mysql > /dev/null -uroot -p${MYSQL_ROOT_PASSWORD} -e 'SELECT 1' >/dev/null; do
    sleep 2
  done

  echo MySQL is up.
  sleep 2

  echo Restoring SQL dump...
  mysql -u root -p${MYSQL_ROOT_PASSWORD} {{ .Values.initData.restoreSql.tableName }} < /initdb/{{ .Values.initData.restoreSql.tableName }}.sql.gz
  kill -15 $pid

  echo Restore successful, removing SQL dump
  rm -rf /initdb/*
{{- end }}
