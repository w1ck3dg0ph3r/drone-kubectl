# drone-kubectl [![Build Status](https://cloud.drone.io/api/badges/w1ck3dg0ph3r/drone-kubectl/status.svg)](https://cloud.drone.io/w1ck3dg0ph3r/drone-kubectl)

[Drone CI](https://drone.io/) plugin that allows you to use preconfigured kubectl

## Example

**.drone.yaml**

```yaml
kind: pipeline
type: docker
name: default
steps:
- name: deploy
  image: w1ck3dg0ph3r/drone-kubectl:latest
  settings:
    myapp_image_tag: ${DRONE_COMMIT:0:8}
    server:
      from_secret: k8s_server
    cert:
      from_secret: k8s_cert
    token:
      from_secret: k8s_token
  commands:
    - kubectl apply -f deployment.yaml
```

**deployment.yaml**
```yaml
# ...
  template:
    metadata:
      labels:
        app: myapp
        commit: ${DRONE_COMMIT_LINK}
        version: ${DRONE_SEMVER}
    spec:
      containers:
      - name: myapp
        image: docker.example.com/myapp:${PLUGIN_MYAPP_IMAGE_TAG}
# ...
```

## Settings

Name | Description
--- | ---
server | Server url (e.g. `https://xxx.xxx.xxx.xxx:6443`).
cert | Server TLS certificate. If not specified, TLS verification will be skipped.
user | Account name. If not specified, `default` is used.
token | Account token (e.g. `default:ney2cm73c3pfmtpbmx7nehhxsvxsjbyejf23zy48jy8p2qfxhfgec2`)
namespace | Default namespace to use. If not specified, namespace `default` is used.
substitute | List of extra files to run variables substitution on.

Any additional settings provided will be available for variable substitution alongside [Drone defined environment variables](https://docker-runner.docs.drone.io/configuration/environment/variables/) under the name `PLUGIN_<uppercase settings name>`.

## Variable Substitution

The variable substitution is performed on any `.yaml` file, referenced in kubectl commands using [`envsubst`](https://linux.die.net/man/1/envsubst). If you need extra files to be processed, specify them in `substitute` setting.

## Building Image


### Build arguments

Argument | Description
--- | ---
KUBECTL_VERSION | `kubectl` version to download. Possible values are `latest`, `stable` or exact version (e.g. `v1.17.3`). The default is `stable`.


*Inspired by [sinlead/drone-kubectl](https://github.com/sinlead/drone-kubectl)*
