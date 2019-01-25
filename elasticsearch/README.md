# Elasticsearch

## Introduction
This chart bootstraps a [elasticsearch](https://github.com/docker-library/elasticsearch) statefulset on a [Kubernetes](https://kubernetes.io/) cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites
- Kubernetes 1.6+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Install
To install the chart with the release name my-release:
```sh
helm install --name my-release jobteaser/elasticsearch
```
The command deploys elasticsearch on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.
> **Tip**: List all releases using `helm list`


## Configuration
The following tables lists the configurable parameters of the elasticsearch chart and their default values.

### Basic
| Parameter | Description                              | Default             |
| ---       | ---                                      | ---                 |
| `image`   | `elasticsearch` image repository and tag | `elasticsearch:2.3` |

### Expert
| Parameter                                 | Description                                                         | Default                   |
| ---                                       | ---                                                                 | ---                       |
| `initData.enabled`                        | Use init container to inject data into elasticsearch                | `false`                   |
| `initData.image`                          | Image and tag used by the init container of data initialization     | `jobteaser/awscli:latest` |
| `initData.datafile`                       | Name of the file to download                                        | `nil`                     |
| `initData.objectStorage.bucket`           | Name of the bucket to download the datafile from                    | `nil`                     |
| `initData.objectStorage.secretKeyRefName` | Name of the k8s secret with `access_key_id` and `secret_access_key` | `nil`                     |
| `service.name`                            | Name of the k8s service                                             | `es`                      |
| `service.type`                            | Type of the k8s service                                             | `ClusterIP`               |
| `service.externalPort`                    | External port exposed by the k8s service                            | `3306`                    |
| `service.internalPort`                    | Internal port of the k8s service                                    | `3306`                    |
| `persistence.storageClassName`            | Storage class name of the persistence volume                        | `default`                 |
| `persistence.accessMode`                  | Access mode of the persistence volume                               | `ReadWriteOnce`           |
| `persistence.size`                        | Internal port of the k8s service                                    | `3306`                    |
| `template.labels`                         | Labels to be added to the elasticsearch pod                         | `{}`                      |
| `resources`                               | Resources limits and requests for elasticsearch                     | `{}`                      |
| `networkPolicy.enabled`                   | Use network policy to filter ingress connections to elasticsearch   | `false`                   |
| `networkPolicy.allowExternal`             | Allow all ingress connections to elasticsearch                      | `nil`                     |
