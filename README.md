# github.com/tiredofit/headscale

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-headscale?style=flat-square)](https://github.com/tiredofit/docker-headscale/releases)
[![Build Status](https://img.shields.io/github/workflow/status/tiredofit/docker-headscale/build?style=flat-square)](https://github.com/tiredofit/docker-headscale/actions?query=workflow%3Abuild)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/headscale.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/headscale/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/headscale.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/headscale/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

## About

This will build a Docker Image for [Headscale](https://github.com/juanfont/headscale), A mesh network.

## Maintainer

- [Dave Conroy](https://github.com/tiredofit/)

## Table of Contents

- [About](#about)
- [Maintainer](#maintainer)
- [Table of Contents](#table-of-contents)
- [Installation](#installation)
  - [Build from Source](#build-from-source)
  - [Prebuilt Images](#prebuilt-images)
    - [Multi Architecture](#multi-architecture)
- [Configuration](#configuration)
  - [Quick Start](#quick-start)
  - [Persistent Storage](#persistent-storage)
  - [Environment Variables](#environment-variables)
    - [Base Images used](#base-images-used)
    - [Container Options](#container-options)
    - [Server Options](#server-options)
  - [Networking](#networking)
- [Maintenance](#maintenance)
  - [Shell Access](#shell-access)
- [Support](#support)
  - [Usage](#usage)
  - [Bugfixes](#bugfixes)
  - [Feature Requests](#feature-requests)
  - [Updates](#updates)
- [License](#license)
- [References](#references)


## Installation
### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/headscale).

```
docker pull tiredofit/headscale:(imagetag)
```

Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/headscale/pkgs/container/headscale)

```
docker pull ghcr.io/tiredofit/docker-headscale:(imagetag)
```

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [compose.yml](examples/compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.
* Map [persistent storage](#data-volumes) for access to configuration and data files for backup.

### Persistent Storage

The following directories are used for configuration and can be mapped for persistent storage.

| Directory  | Description                     |
| ---------- | ------------------------------- |
| `/config/` | Configuration Files             |
| `/data/`   | Database files and private keys |
| `/logs/`   | Headscale Server Logs           |

* * *
### Environment Variables

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`,`nano`,`vim`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |


#### Container Options
| Variable      | Value                               | Default    |
| ------------- | ----------------------------------- | ---------- |
| `CONFIG_PATH` |                                     | `/config/` |
| `DATA_PATH`   |                                     | `/data/`   |
| `LOG_PATH`    |                                     | `/logs/`   |
| `LOG_TYPE`    |                                     | `FILE`     |
| `MODE`        | `CLIENT` `SERVER` `STANDALONE` `UI` | `SERVER`   |
| `SETUP_MODE`  |                                     | `AUTO`     |

#### Server Options
| Variable                        | Value                     | Default               |
| ------------------------------- | ------------------------- | --------------------- |
| `SERVER_CONFIG_FILE`            |                           | `headscale.yaml`      |
| `SERVER_DB_SQLITE_FILE`         |                           | `headscale.sqlite`    |
| `SERVER_DB_TYPE`                | `sqlite3` or `postgresql` | `sqlite3`             |
| `SERVER_GRPC_LISTEN_IP`         |                           | `127.0.0.1`           |
| `SERVER_GRPC_LISTEN_PORT`       |                           | `50443`               |
| `SERVER_LISTEN_IP`              |                           | `0.0.0.0`             |
| `SERVER_LISTEN_PORT`            |                           | `8080`                |
| `SERVER_LOG_FILE`               |                           | `server.log`          |
| `SERVER_LOG_FORMAT`             |                           | `text`                |
| `SERVER_LOG_LEVEL`              |                           | `INFO`                |
| `SERVER_METRICS_LISTEN_IP`      |                           | `127.0.0.1`           |
| `SERVER_METRICS_LISTEN_PORT`    |                           | `9090`                |
| `SERVER_NOISE_PRIVATE_KEY_FILE` |                           | `noise_private.key`   |
| `SERVER_PRIVATE_KEY_FILE`       |                           | `private.key`         |
| `SOCKET_FILE`                   |                           | `headscale.sock`      |
| `SOCKET_PATH`                   |                           | `/var/run/headspace/` |
| `SOCKET_PERMISSION`             |                           | `0770`                |

### Networking

| Port   | Protocol | Description        |
| ------ | -------- | ------------------ |
| `8080` | `tcp`    | Headscale Server   |
| `80`   | `tcp`    | Nginx Headscale UI |

## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is) bash
```
## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for personalized support.
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.

## References

* <https://github.com/juanfont/headscale>
