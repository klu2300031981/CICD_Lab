{{/*
Expand the name of the chart.
*/}}
{{- define "bloodbank.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "bloodbank.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "bloodbank.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "bloodbank.labels" -}}
helm.sh/chart: {{ include "bloodbank.chart" . }}
{{ include "bloodbank.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "bloodbank.selectorLabels" -}}
app.kubernetes.io/name: {{ include "bloodbank.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Backend labels
*/}}
{{- define "bloodbank.backend.labels" -}}
{{ include "bloodbank.labels" . }}
app.kubernetes.io/component: backend
{{- end }}

{{/*
Frontend labels
*/}}
{{- define "bloodbank.frontend.labels" -}}
{{ include "bloodbank.labels" . }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
MySQL labels
*/}}
{{- define "bloodbank.mysql.labels" -}}
{{ include "bloodbank.labels" . }}
app.kubernetes.io/component: mysql
{{- end }}


