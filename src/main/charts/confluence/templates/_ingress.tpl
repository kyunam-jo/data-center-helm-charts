{{- define "confluence.ingress.tpl" }}
{{/* Change to networking.k8s.io/v1 when k8s 1.19 is the oldest supported version */}}
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: {}
  labels:
    {{- include "confluence.labels" . | nindent 4 }}
  annotations:
    {{ if .Values.ingress.nginx }}
    "kubernetes.io/ingress.class": "nginx"
    "nginx.ingress.kubernetes.io/affinity": "cookie"
    "nginx.ingress.kubernetes.io/affinity-mode": "persistent"
    "nginx.ingress.kubernetes.io/proxy-body-size": {{ .Values.ingress.maxBodySize }}
    {{- end }}
    {{- with .Values.ingress.annotations }}
  {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
{{ if and (.Values.ingress.tlsSecretName) (.Values.ingress.host) }}
  tls:
    - hosts:
        - {{ .Values.ingress.host }}
      secretName: {{ .Values.ingress.tlsSecretName }}
{{ end }}
  rules: {}
{{ end }}
{{- define "confluence.ingress" -}}
{{- include "common.util.merge" (append . "confluence.ingress.tpl") -}}
{{ end }}