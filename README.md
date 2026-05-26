# openchoreo-single

A single Helm chart that installs OpenChoreo by running a Kubernetes Job that orchestrates the official OpenChoreo OCI Helm charts in order.

Why this pattern: OpenChoreo is intentionally split into separate control, data, workflow, and observability plane charts. The official docs install them sequentially and copy/register plane certificates between steps. This chart wraps that flow behind one `helm install`.

## Install

```bash
helm install openchoreo-single ./openchoreo-single \
  --namespace openchoreo-installer \
  --create-namespace
```

Watch progress:

```bash
kubectl logs -n openchoreo-installer job/openchoreo-single-openchoreo-single -f
```

## Minimal local install

The default installs prerequisites, the control plane, and one data plane. Workflow and observability are off by default:

```yaml
workflowPlane:
  enabled: false
observabilityPlane:
  enabled: false
```

## Enable workflow plane

```bash
helm upgrade --install openchoreo-single ./openchoreo-single \
  -n openchoreo-installer \
  --set workflowPlane.enabled=true \
  --set workflowPlane.installWorkflowTemplates=true
```

## Enable observability plane

```bash
helm upgrade --install openchoreo-single ./openchoreo-single \
  -n openchoreo-installer \
  --set observabilityPlane.enabled=true
```

## OpenShift note

If your cluster already manages Kubernetes Gateway API CRDs, disable Gateway API CRD installation:

```bash
--set prerequisites.gatewayApi.enabled=false
```

## Important notes

- This chart needs cluster-admin-like permissions because OpenChoreo installs CRDs and cluster-scoped resources.
- The default OpenChoreo chart version is `1.1.0`. Override with `--set openchoreo.version=<version>`.
- This chart installs child releases with Helm from inside the cluster. Uninstall the child releases separately if you remove OpenChoreo.
