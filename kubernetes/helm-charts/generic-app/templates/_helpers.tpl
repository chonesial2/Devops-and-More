{{/*
Expand the name of the app and env.
*/}}
{{- define "app.name" -}}
{{- .Values.app.appName | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "app.env" -}}
{{- .Values.app.environment }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "app.labels" -}}
helm.sh/chart: '{{ include "app.name" . }}-{{ include "app.env" . }}'
{{ include "app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app.name" . | quote }}
app.kubernetes.io/env: {{ include "app.env" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}
