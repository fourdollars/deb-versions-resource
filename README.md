 [![GitHub: fourdollars/deb-versions-resource](https://img.shields.io/badge/GitHub-fourdollars%2Fdeb%E2%80%90versions%E2%80%90resource-darkgreen.svg)](https://github.com/fourdollars/deb-versions-resource/) [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT) [![Bash](https://img.shields.io/badge/Language-Bash-red.svg)](https://www.gnu.org/software/bash/) ![Docker](https://github.com/fourdollars/deb-versions-resource/workflows/Docker/badge.svg) [![Docker Pulls](https://img.shields.io/docker/pulls/fourdollars/deb-versions-resource.svg)](https://hub.docker.com/r/fourdollars/deb-versions-resource/)
# deb-versions-resource
[concourse-ci](https://concourse-ci.org/)'s deb-versions-resource to watch the versions of Debian binary packages and download those Debian binary packages.

## Config 

### Resource Type

```yaml
resource_types:
- name: resource-deb-versions
  type: registry-image
  source:
    repository: fourdollars/deb-versions-resource
    tag: latest
```

or

```yaml
resource_types:
- name: resource-deb-versions
  type: registry-image
  source:
    repository: ghcr.io/fourdollars/deb-versions-resource
    tag: latest
```

### Resource

* mirror: optional, http://archive.ubuntu.com/ubuntu/ by default.
* codename: optional, if you want to use the general archives of Debian or Ubuntu.
* archive: optional, the line of source list or ppa:YourName/YourPPA for Ubuntu.
* fingerprint: optional, the finerprint of the PPA.
* username: optional, the username of the private PPA.
* password: optional, the password of the private PPA.
* packages: **required**, the Debian binary packages.
* download: optional, false by default.
* allow_not_found: optional, false by default, allow any package not found
* if_any_found: optional, false by default, if any package is found. This option will override allow_not_found.

```yaml
resources:
- name: versions
  icon: counter
  type: resource-deb-versions
  check_every: 30m
  source:
    mirror: http://deb.debian.org/debian
    codename: buster
    archive: "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
    fingerprint: EB4C1BFD4F042F6DDDCCEC917721F63BD38B4796
    download: true
    packages:
      - firefox-esr
      - google-chrome-stable
```

### Example

```yaml
jobs:
- name: check-versions
  plan:
  - get: versions
    trigger: true
  - task: check
    config:
      platform: linux
      image_resource:
        type: registry-image
        source:
          repository: busybox
      inputs:
        - name: versions
      run:
        path: sh
        args:
        - -exc
        - |
          cd versions
          cat versions.log
          ls -lh *
```
