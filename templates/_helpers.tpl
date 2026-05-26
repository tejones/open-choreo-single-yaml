{{- define "openchoreo-single.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- define "openchoreo-single.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "openchoreo-single.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- define "openchoreo-single.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "openchoreo-single.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
