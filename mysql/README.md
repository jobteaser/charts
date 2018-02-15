# MySQL

## Introduction
This chart bootstraps a [MySQL](https://github.com/docker-library/mysql) statefulset on a [Kubernetes](https://kubernetes.io/) cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites
- Kubernetes 1.6+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Install
To install the chart with the release name my-release:
```sh
helm install --name my-release jobteaser/mysql
```
The command deploys MySQL on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.
> **Tip**: List all releases using `helm list`


## Configuration
The following tables lists the configurable parameters of the MySQL chart and their default values.

### Basic
| Parameter          | Description                                                                                                                                   | Default     |
| ---                | ---                                                                                                                                           | ---         |
| `image`            | `mysql` image repository and tag                                                                                                              | `mysql:5.6` |
| `database`         | Name of the database created by MySQL at init                                                                                                 | `mysql`     |
| `secretKeyRefName` | K8s secret name with `root_password`, `username` and `password` keys to setup MySQL. If set to `nil`, it will generate a random root password | `nil`       |

### Expert
| Parameter                                 | Description                                                         | Default           |
| ---                                       | ---                                                                 | ---               |
| `initData.enabled`                        | Use init container to inject data into MySQL                        | `false`           |
| `initData.image`                          | Image and tag used by the init container of data initialization     | `minio/mc:latest` |
| `initData.datafile`                       | Name of the file to download                                        | `nil`             |
| `initData.objectStorage.provider`         | Name of the provider to download the datafile from                  | `nil`             |
| `initData.objectStorage.bucket`           | Name of the bucket to download the datafile from                    | `nil`             |
| `initData.objectStorage.host`             | Name of the host to download the datafile from                      | `nil`             |
| `initData.objectStorage.secretKeyRefName` | Name of the k8s secret with `access_key_id` and `secret_access_key` | `nil`             |
| `service.name`                            | Name of the k8s service                                             | `mysql`           |
| `service.type`                            | Type of the k8s service                                             | `ClusterIP`       |
| `service.externalPort`                    | External port exposed by the k8s service                            | `3306`            |
| `service.internalPort`                    | Internal port of the k8s service                                    | `3306`            |
| `persistence.storageClassName`            | Storage class name of the persistence volume                        | `default`         |
| `persistence.accessMode`                  | Access mode of the persistence volume                               | `ReadWriteOnce`   |
| `persistence.size`                        | Internal port of the k8s service                                    | `3306`            |
| `template.labels`                         | Labels to be added to the MySQL pod                                 | `{}`              |
| `resources`                               | Resources limits and requests for MySQL                             | `{}`              |
| `networkPolicy.enabled`                   | Use network policy to filter ingress connections to MySQL           | `false`           |
| `networkPolicy.allowExternal`             | Allow all ingress connections to MySQL                              | `nil`             |
