# Content Security Policy Handler

## Introduction
This chart bootstraps a [CSP Handler](https://github.com/jobteaser/csp-handler/) deployment on a [Kubernetes](https://kubernetes.io/) cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites
- Kubernetes 1.6+ with Beta APIs enabled

## Install
To install the chart with the release name my-release:
```sh
helm install --name my-release jobteaser/csp-handler
```
The command deploys CSP Handler on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.
> **Tip**: List all releases using `helm list`


## Configuration
The following tables lists the configurable parameters of the CSP Handler chart and their default values.

### Basic
| Parameter                     | Description                                     | Default                                                    |
| -----------------------       | ---------------------------------------------   | ---------------------------------------------------------- |
| `image.repository`            | `csp-handler` image repository and tag          | `csp-handler:v1.0.0`                                       |
| `image.tag`                   | The tag to use of the image                     | `v1.0.0`                                                   |
| `image.pullPolicy`            | The pull policy of the image                    | `IfNotPresent`                                             |

### Expert

| Parameter                     | Description                                     | Default                                                    |
| -----------------------       | ---------------------------------------------   | ---------------------------------------------------------- |
| `service.port`                | TCP port use by the csp-handler-server          | `80`                                                       |
| `service.type`                | The service type                                | `ClusterIP`                                                |
| `ingress.enabled`             |                                                 | `false`                                                    |
| `ingress.annotations`         |                                                 | `{}`                                                       |
| `ingress.path`                |                                                 | `/`                                                        |
| `ingress.hosts`               |                                                 | `csp-handler.local`                                        |
| `ingress.tls`                 |                                                 | `[]`                                                       |
| `replicaCount`                | Number of csp-handler instances                 | `1`                                                        |
| `resources`                   | CPU/Memory resource requests/limits             | `{}`                                                       |
| `nodeSelector`                |                                                 | `{}`                                                       |
| `tolerations`                 |                                                 | `[]`                                                       |
| `affinity`                    |                                                 | `{}`                                                       |
