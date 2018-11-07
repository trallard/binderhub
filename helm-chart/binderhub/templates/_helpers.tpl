{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Render docker config.json for the registry-publishing secret.
*/}}
{{- define "registryDockerConfig" -}}

{{- /* default auth url */ -}}
{{- $url := (default "https://index.docker.io/v1" .Values.registry.url) }}

{{- /* default username if unspecified
  (_json_key for gcr.io, <token> otherwise)
*/ -}}

{{- if not .Values.registry.username }}
  {{- if eq $url "https://gcr.io" }}
    {{- $_ := set .Values.registry "username" "_json_key" }}
  {{- else }}
    {{- $_ := set .Values.registry "username" "<token>" }}
  {{- end }}
{{- end }}
{{- $username := .Values.registry.username -}}

{
  "auths": {
    "{{ $url }}": {
      "auth": "{{ printf "%s:%s" $username .Values.registry.password | b64enc }}"
    }
  }
}
{{- end }}
