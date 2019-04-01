# GLPI

## Introduction
This chart bootstraps a [GLPI](https://github.com/jobteaser/dockerfiles/glpi) statefulset on a [Kubernetes](https://kubernetes.io/) cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites
- Kubernetes 1.6+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure

## Install
To install the chart with the release name my-release:
```sh
helm install --name my-release jobteaser/glpi
```
The command deploys GLPI on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.
> **Tip**: List all releases using `helm list`


## Configuration
The following tables lists the configurable parameters of the MySQL chart and their default values.

### Basic
| Parameter          | Description                                                                                          | Default                 |
| ---                | ---                                                                                                  | ---                     |
| `Image`            | `glpi` image repository and tag                                                                      | `jobteaser/glpi:latest` |
| `SecretKeyRefName` | K8s secret name which contains `root_password`, `username` and `password` keys to connect to MySQL.  | `secret`                |

### Expert
| Parameter                                 | Description                                                         | Default                   |
| ---                                       | ---                                                                 | ---                       |
| `config.dbHost`                           | Name or IP of the mysql endpoint                                    | `mysql-glpi`              |
| `config.dbName`                           | Name of the Database                                                | `glpi`                    |
| `config.defaultLang`                      | Default GLPI language                                               | `en_EN`                   |
| `ingress.enabled`                         | Enable ingress                                                      | `false`                   |
| `ingress.annotations`                     | Annotations of the ingress object                                   | `{}`                      |
| `ingress.path`                            | Path handled by the ingress object                                  | `/`                       |
| `ingress.hosts`                           | List of hosts of the ingress object                                 | `[]`                      |
| `ingress.tls.SecretName`                  | Name of the secret used to terminate SSL traffic on 443             | `secret-tls`              |
| `ingress.tls.Hosts`                       | List of hosts included in the TLS certificate                       | `false`                   |
| `service.name`                            | Name of the k8s service                                             | `glpi`                    |
| `service.type`                            | Type of the k8s service                                             | `ClusterIP`               |
| `service.externalPort`                    | External port exposed by the k8s service                            | `80`                      |
| `service.internalPort`                    | Internal port of the k8s service                                    | `80`                      |
| `persistence.storageClassName`            | Storage class name of the persistence volume                        | `default`                 |
| `persistence.accessMode`                  | Access mode of the persistence volume                               | `ReadWriteOnce`           |
| `persistence.size`                        | Size allocated for the PVC object                                   | `5Gi`                     |
| `template.labels`                         | Labels to be added to the GLPI pod                                  | `{}`                      |
| `resources`                               | Resources limits and requests                                       | `{}`                      |
