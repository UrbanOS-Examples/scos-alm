{{/* vim: set filetype=mustache: */}}
{{/*
Create a common label block
*/}}
{{- define "bootstrap.labels" -}}
environment: {{ .Values.global.environment }}
chart: {{ .Chart.Name }}-{{ .Chart.Version }}
release: {{ .Release.Name }}
source: helm
{{- end -}}
{{- define "bootstrap.resources" -}}
limits:
  memory: {{ .Values.resourceLimits.memory }}
  cpu: {{ .Values.resourceLimits.cpu }}
requests:
  memory: {{ .Values.resourceLimits.memory }}
  cpu: {{ .Values.resourceLimits.cpu }}
{{- end -}}
