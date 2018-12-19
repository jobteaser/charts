# ci-connector

## Installation

The main parameter is `script` that represents the ruby script
```
# file: values.override.yaml

script: |
  require "CI/connector"
  
  conn = CI::Connector.from_env()
  conn.on('github.pull_request') do |event|
    if event['action'] == 'closed'
      conn.logger.info "Close #{event['repository']['full_name']} PR #{event['number']}"
    end
  end
  conn.start
  
  trap("TERM") { conn.stop }
  trap("INT") { conn.stop }

```

### Basic
| Parameter                     | Description                                     | Default                                                    |
| -----------------------       | ---------------------------------------------   | ---------------------------------------------------------- |
| `image`                       | image repository and tag                        | `docker.k8s.jobteaser.net/coretech/ci-connector:latest`    |
| `script`                      | the ruby script                                 | ``                                                   |

Then deploy
```
helm upgrade --install -f values.override.yaml --name my-connector jobteaser/ci-connector
```
