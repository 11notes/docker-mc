![banner](https://raw.githubusercontent.com/11notes/static/refs/heads/main/img/banner/README.png)

# MC
![size](https://img.shields.io/badge/image_size-21MB-green?color=%2338ad2d)![5px](https://raw.githubusercontent.com/11notes/static/refs/heads/main/img/markdown/transparent5x2px.png)![pulls](https://img.shields.io/docker/pulls/11notes/mc?color=2b75d6)![5px](https://raw.githubusercontent.com/11notes/static/refs/heads/main/img/markdown/transparent5x2px.png)[<img src="https://img.shields.io/github/issues/11notes/docker-mc?color=7842f5">](https://github.com/11notes/docker-mc/issues)![5px](https://raw.githubusercontent.com/11notes/static/refs/heads/main/img/markdown/transparent5x2px.png)![swiss_made](https://img.shields.io/badge/Swiss_Made-FFFFFF?labelColor=FF0000&logo=data:image/svg%2bxml;base64,PHN2ZyB2ZXJzaW9uPSIxIiB3aWR0aD0iNTEyIiBoZWlnaHQ9IjUxMiIgdmlld0JveD0iMCAwIDMyIDMyIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPgogIDxyZWN0IHdpZHRoPSIzMiIgaGVpZ2h0PSIzMiIgZmlsbD0idHJhbnNwYXJlbnQiLz4KICA8cGF0aCBkPSJtMTMgNmg2djdoN3Y2aC03djdoLTZ2LTdoLTd2LTZoN3oiIGZpbGw9IiNmZmYiLz4KPC9zdmc+)

Run mc rootless and distroless.

# INTRODUCTION 📢

[MinIO Client (mc)](https://github.com/minio/mc) (created by [minio](https://github.com/minio)) provides a modern alternative to UNIX commands like ls, cat, cp, mirror, diff, find etc. It supports filesystems and Amazon S3 compatible cloud storage service (AWS Signature v2 and v4).

# SYNOPSIS 📖
**What can I do with this?** This image will run mc [rootless](https://github.com/11notes/RTFM/blob/main/linux/container/image/rootless.md) and [distroless](https://github.com/11notes/RTFM/blob/main/linux/container/image/distroless.md), for maximum security and performance. In addition to being small and secure, it will also automatically create the **minio** alias with the user set via environment variables.

# UNIQUE VALUE PROPOSITION 💶
**Why should I run this image and not the other image(s) that already exist?** Good question! Because ...

> [!IMPORTANT]
>* ... this image runs [rootless](https://github.com/11notes/RTFM/blob/main/linux/container/image/rootless.md) as 1000:1000
>* ... this image has no shell since it is [distroless](https://github.com/11notes/RTFM/blob/main/linux/container/image/distroless.md)
>* ... this image is auto updated to the latest version via CI/CD
>* ... this image has a health check
>* ... this image runs read-only
>* ... this image is automatically scanned for CVEs before and after publishing
>* ... this image is created via a secure and pinned CI/CD process
>* ... this image is very small

If you value security, simplicity and optimizations to the extreme, then this image might be for you.

# COMPARISON 🏁
Below you find a comparison between this image and the most used or original one.

| **image** | **size on disk** | **init default as** | **[distroless](https://github.com/11notes/RTFM/blob/main/linux/container/image/distroless.md)** | supported architectures
| ---: | ---: | :---: | :---: | :---: |
| 11notes/mc | 21MB | 1000:1000 | ✅ | amd64, arm64, armv7 |
| minio/mc | 84MB | 0:0 | ❌ | amd64, arm64, ppc64le |

# VOLUMES 📁
* **/mc/etc** - Directory of mc config

# COMPOSE ✂️
Checkout [compose.secrets.yml](https://github.com/11notes/docker-mc/blob/master/compose.secrets.yml) if you want to use secrets instead of environment variables.
```yaml
name: "s3"

x-lockdown: &lockdown
  # prevents write access to the image itself
  read_only: true
  # prevents any process within the container to gain more privileges
  security_opt:
    - "no-new-privileges=true"

services:    
  minio:
    # for more information about this image checkout:
    # https://github.com/11notes/docker-minio
    image: "11notes/minio:2025.10.15"
    hostname: "minio"
    <<: *lockdown
    environment:
      TZ: "Europe/Zurich"
      MINIO_ROOT_PASSWORD: "${MINIO_ROOT_PASSWORD}"
    # in stand-alone (no disks) simply use /mnt as your command
    # then mount any volume to /mnt to store your data
    command: "/mnt"
    ports:
      - "3000:9001/tcp"
      - "9000:9000/tcp"
    volumes:
      - "minio.var:/mnt"
    networks:
      backend:
    restart: "always"

  mc:
    depends_on:
      minio:
        condition: "service_healthy"
        restart: true
    image: "11notes/mc:2025.08.13"
    <<: *lockdown
    environment:
      TZ: "Europe/Zurich"
      MC_MINIO_URL: "https://minio:9000"
      MC_MINIO_ROOT_PASSWORD: "${MINIO_ROOT_PASSWORD}"
      MC_INSECURE: true
    command:
      - ready minio
      - mb --ignore-existing minio/default
    volumes:
      - "mc.etc:/mc/etc"
    networks:
      backend:
    restart: "no"

volumes:
  minio.var:
  mc.etc:

networks:
  frontend:
  backend:
    internal: true
```
To find out how you can change the default UID/GID of this container image, consult the [RTFM](https://github.com/11notes/RTFM/blob/main/linux/container/image/11notes/how-to.changeUIDGID.md#change-uidgid-the-correct-way).

# DEFAULT SETTINGS 🗃️
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user name |
| `uid` | 1000 | [user identifier](https://en.wikipedia.org/wiki/User_identifier) |
| `gid` | 1000 | [group identifier](https://en.wikipedia.org/wiki/Group_identifier) |
| `home` | /mc | home directory of user docker |

# ENVIRONMENT 📝
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Will activate debug option for container image and app (if available) | |
| `MC_MINIO_URL` | URL of minio server to connect to |  |
| `MC_MINIO_ROOT_USER` | username of admin account | admin |
| `MC_MINIO_ROOT_PASSWORD` | password of root user |  |
| `MC_MINIO_ROOT_PASSWORD_FILE` | password file of root user for secrets |  |
| `MC_ALIAS` | alias used to access minio | minio |
| `MC_*` | all other available [settings](https://docs.min.io/enterprise/aistor-object-store/reference/cli/aistor-client-settings/) |  |

# MAIN TAGS 🏷️
These are the main tags for the image. There is also a tag for each commit and its shorthand sha256 value.

* [2025.08.13](https://hub.docker.com/r/11notes/mc/tags?name=2025.08.13)

### There is no latest tag, what am I supposed to do about updates?
It is my opinion that the ```:latest``` tag is a bad habbit and should not be used at all. Many developers introduce **breaking changes** in new releases. This would messed up everything for people who use ```:latest```. If you don’t want to change the tag to the latest [semver](https://semver.org/), simply use the short versions of [semver](https://semver.org/). Instead of using ```:2025.08.13``` you can use ```:2025``` or ```:2025.08```. Since on each new version these tags are updated to the latest version of the software, using them is identical to using ```:latest``` but at least fixed to a major or minor version. Which in theory should not introduce breaking changes.

If you still insist on having the bleeding edge release of this app, simply use the ```:rolling``` tag, but be warned! You will get the latest version of the app instantly, regardless of breaking changes or security issues or what so ever. You do this at your own risk!

# REGISTRIES ☁️
```
docker pull 11notes/mc:2025.08.13
docker pull ghcr.io/11notes/mc:2025.08.13
docker pull quay.io/11notes/mc:2025.08.13
```

# SOURCE 💾
* [11notes/mc](https://github.com/11notes/docker-mc)

# PARENT IMAGE 🏛️
> [!IMPORTANT]
>This image is not based on another image but uses [scratch](https://hub.docker.com/_/scratch) as the starting layer.
>The image consists of the following distroless layers that were added:
>* [11notes/distroless](https://github.com/11notes/docker-distroless/blob/master/arch.dockerfile) - contains users, timezones and Root CA certificates, nothing else

# BUILT WITH 🧰
* [minio/minio](https://github.com/minio/minio)

# GENERAL TIPS 📌
> [!TIP]
>* Use a reverse proxy like Traefik, Nginx, HAproxy to terminate TLS and to protect your endpoints
>* Use Let’s Encrypt DNS-01 challenge to obtain valid SSL certificates for your services

# CAUTION ⚠️
> [!CAUTION]
>* The compose example uses ```MC_INSECURE```. Never do this in production! Use a valid SSL certificate to terminate your minio!

# ElevenNotes™️
This image is provided to you at your own risk. Always make backups before updating an image to a different version. Check the [releases](https://github.com/11notes/docker-mc/releases) for breaking changes. If you have any problems with using this image simply raise an [issue](https://github.com/11notes/docker-mc/issues), thanks. If you have a question or inputs please create a new [discussion](https://github.com/11notes/docker-mc/discussions) instead of an issue. You can find all my other repositories on [github](https://github.com/11notes?tab=repositories).

*created 07.01.2026, 23:24:42 (CET)*