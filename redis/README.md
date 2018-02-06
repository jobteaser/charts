# Redis

## Introduction
This chart bootstraps a [Redis](https://hub.docker.com/_/redis/) statefulset on a [Kubernetes](https://kubernetes.io/) cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites
- Kubernetes 1.6+ with Beta APIs enabled
- PV provisioner support in the underlying infrastructure (Only when persisting data)

## Install
To install the chart with the release name my-release:
```sh
helm install --name my-release jobteaser/redis
```
The command deploys Redis on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.
> **Tip**: List all releases using `helm list`


## Configuration
The following tables lists the configurable parameters of the Redis chart and their default values.

### Basic
| Parameter                     | Description                                     | Default                                                    |
| -----------------------       | ---------------------------------------------   | ---------------------------------------------------------- |
| `image`                       | `redis` image repository and tag                | `redis:3.2`                                                |

### Expert
| Parameter                     | Description                                     | Default                                                    |
| -----------------------       | ---------------------------------------------   | ---------------------------------------------------------- |
| `port`                        | TCP port use by the redis-server                | `6379`                                                     |
| `replicaCount`                | Number of redis instances                       | `1`                                                        |
| `sentinel.enabled`            | Use sentinel to have high availability database | `false`                                                    |
| `sentinel.quorum`             | Size of sentinel to elect new redis master      | `nil`                                                      |
| `sentinel.port`               | TCP port use by the sentinel-server             | `nil`                                                      |
| `persistence.enabled`         | Use a PVC to persist data                       | `false`                                                    |
| `persistence.storageClass`    | Storage class of backing PVC                    | `nil` (uses alpha storage class annotation)                |
| `persistence.accessMode`      | Use volume as ReadOnly or ReadWriteOnce         | `nil`                                                      |
| `persistence.annotations`     | Persistent Volume annotations                   | `{}`                                                       |
| `persistence.size`            | Size of data volume                             | `nil`                                                      |
| `resources`                   | CPU/Memory resource requests/limits             | Memory: `256Mi`, CPU: `100m`                               |
| `networkPolicy.enabled`       | Use network policy to protect the redis cluster | `false`                                                    |
| `networkPolicy.allowExternal` | Allow all pod to access to redis cluster        | `nil`                                                      |
