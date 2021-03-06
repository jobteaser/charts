# PostgreSQL

## Introduction
This chart bootstraps a [PostgreSQL](https://github.com/docker-library/postgres) statefulset on a [Kubernetes](https://kubernetes.io/) cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites
- Kubernetes 1.6+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure (Only when persisting data)

## Install
To install the chart with the release name my-release:
```sh
helm install --name my-release jobteaser/postgres
```
The command deploys PostgreSQL on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.
> **Tip**: List all releases using `helm list`


## Configuration
The following tables lists the configurable parameters of the PostgresSQL chart and their default values.

### Basic
| Parameter          | Description                         | Default                                                 |
| ---                | ---                                 | ---                                                     |
| `image`            | `postgres` image repository and tag | `postgres:9.6`                                          |
| `imagePullPolicy`  | Image pull policy                   | `Always` if `imageTag` is `latest`, else `IfNotPresent` |
| `imagePullSecrets` | Image pull secrets                  | `nil`                                                   |
| `postgresUser`     | Username of new user to create.     | `postgres`                                              |
| `postgresDatabase` | Name for new database to create.    | `postgres`                                              |

### Expert
| Parameter                                 | Description                                              | Default                                     |
| ---                                       | ---                                                      | ---                                         |
| `secret.enabled`                          | Use secret to set postgres password                      | `false`                                     |
| `secret.secretName`                       | Secret store name                                        | `nil`                                       |
| `secret.postgresPassword`                 | Secret store key for postgres password                   | `nil`                                       |
| `persistence.enabled`                     | Use a PVC to persist data                                | `false`                                     |
| `persistence.storageClass`                | Storage class of backing PVC                             | `nil` (uses alpha storage class annotation) |
| `persistence.accessMode`                  | Use volume as ReadOnly or ReadWriteOnce                  | ``                             |
| `persistence.annotations`                 | Persistent Volume annotations                            | `{}`                                        |
| `persistence.size`                        | Size of data volume                                      | `8Gi`                                       |
| `persistence.subPath`                     | Subdirectory of the volume to mount at                   | `postgresql-db`                             |
| `resources`                               | CPU/Memory resource requests/limits                      | Memory: `256Mi`, CPU: `100m`                |
| `service.port`                            | TCP port                                                 | `5432`                                      |
| `service.type`                            | k8s service type exposing ports, e.g. `NodePort`         | `ClusterIP`                                 |
| `initData.enabled`                        | Initialize volume with data from given source            | `false`                                     |
| `initData.datafile`                       | Name of the archive to download                          | `nil`                                     |
| `initData.imageTag`                       | Image tag to use in the init container                   | `latest`                                    |
| `initData.objectStorage.provider`         | Povider of the source, e.g. minio or s3                  | `nil`                                     |
| `initData.objectStorage.bucket`           | Bucket name                                              | `nil`                                     |
| `initData.objectStorage.host`             | Host of the object storage                               | `nil`                                     |
| `initData.objectStorage.secretKeyRefName` | Secret name which contains the access key and secret key | `nil`                                     |
| `networkPolicy.enabled` | Enable network policy | `false`                                     |
| `networkPolicy.allowExternal` | Allow connection from outisde the namespace | `nil`                                     |


