# Base container for Python cron scripts

## Installation

```
docker pull srittau/cron:latest
```

## Usage

In your `Dockerfile`:

```
FROM srittau/cron:latest
```

You will also need two files in your build directory:

* A `crontab` file. A sample crontab is included. Python modules can be run using the `/app/run-module.sh` script.
* A `requirements.txt` file. Packages listed there will be installed into the docker image.
* A `msmtprc` configuration file. If you don't want to send mail, this file can be empty. A sample file is included.

Your Python modules should be copied into the `/app/src` directory in your image.
