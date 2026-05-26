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

{{/*
Determine the Service Annotations based on the provider
*/}}
{{define "openchoreo.serviceAnnotations" -}}
{{- if eq .Values.ingressController.provider "metallb" }}
metallb.universe.tf/address-pool: {{ .Values.ingressController.service.metallbPool | quote }}
{{- else if eq .Values.ingressController.provider "aws" }}
service.beta.kubernetes.io/aws-load-balancer-type: "external"
service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: {{ .Values.ingressController.service.awsTargetType | quote }}
service.beta.kubernetes.io/aws-load-balancer-scheme: {{ .Values.ingressController.service.awsScheme | quote }}
{{- end }}
{{- end }}

{{/*
Construct the full domain names for each plane using the structured values context
*/}}
{{define "controlPlane.url" -}}
{{ .Values.controlPlane.subdomain }}.{{ .Values.openchoreo.domain }}
{{- end }}

{{define "dataPlane.url" -}}
{{ .Values.dataPlane.subdomain }}.{{ .Values.openchoreo.domain }}
{{- end }}

{{define "workflowPlane.url" -}}
{{ .Values.workflowPlane.subdomain }}.{{ .Values.openchoreo.domain }}
{{- end }}

{{define "observabilityPlane.url" -}}
{{ .Values.observabilityPlane.subdomain }}.{{ .Values.openchoreo.domain }}
{{- end }}