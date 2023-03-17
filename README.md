# Base container for Python cron scripts

## Installation

One of:

```
docker pull srittau/cron:latest-copy
docker pull srittau/cron:latest-onbuild
```

## Usage

There are two variants of the image: `onbuild` and `copy`. The `onbuild`
requires several files in your build directory:

* A `crontab` file. A sample crontab is included. Python modules can be run using the `/app/run-module.sh` script.
* A `msmtprc` configuration file. If you don't want to send mail, this file can be empty. A sample file is included.

In your `Dockerfile`:

```
FROM srittau/cron:py3.11-onbuild
```

The `copy` variant requires you to copy your Python modules into the image
yourself. In your `Dockerfile`:

```
FROM srittau/cron:py3.11-copy

COPY ./crontab /etc/crontab
COPY ./msmtprc /root/.msmtprc
```

Copying the .msmtprc file is optional. By default, the image will not send
mail.

Your Python modules should be copied into the `/app/src` directory in your
image. You can also copy or mount a environment file to `/app/env`. Shell
variables in this file are added to the environment before running your
scripts.
