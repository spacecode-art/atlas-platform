{{/* One release per workload: the release name is the app name. */}}
{{- define "atlas-app.name" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Selector labels are immutable on a Deployment. Keep this set minimal. */}}
{{- define "atlas-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "atlas-app.name" . }}
{{- end -}}

{{- define "atlas-app.labels" -}}
{{ include "atlas-app.selectorLabels" . }}
app.kubernetes.io/part-of: atlas
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
{{- end -}}

{{- define "atlas-app.image" -}}
{{- $repo := required "image.repository is required" .Values.image.repository -}}
{{- if .Values.image.digest -}}
{{- printf "%s@%s" $repo .Values.image.digest -}}
{{- else -}}
{{- printf "%s:%s" $repo (required "image.tag or image.digest is required" .Values.image.tag) -}}
{{- end -}}
{{- end -}}