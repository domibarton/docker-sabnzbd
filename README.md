## About

This is a Docker image for [SABnzbd](http://sabnzbd.org/) - the Open Source Binary Newsreader written in Python.

The Docker image currently supports:

* running SABnzbd under its __own user__ (not `root`)
* changing of the __UID and GID__ for the SABnzbd user
* support for OpenSSL / HTTPS encryption
* support for __RAR archives__
* support for __ZIP archives__
* support for __7Zip archives__ ([with SABnzbd version >= 0.8](#improvements-for-sabnzbd-version--08))
* support for the latest `par2` repair utility ([improved with SABnzbd version >= 0.8](#improvements-for-sabnzbd-version--08))

## Run

### Run via Docker CLI client

To run the SABnzbd container you can execute:

```bash
docker run --name sabnzbd -v <datadir path>:/datadir -v <media path>:/media -p 8080:8080 sabnzbd/sabnzbd
```

Open a browser and point it to [http://my-docker-host:8080](http://my-docker-host:8080)

### Run via Docker Compose

You can also run the SABnzbd container by using [Docker Compose](https://www.docker.com/docker-compose).

If you've cloned the [git repository](https://github.com/domibarton/docker-sabnzbd) you can build and run the Docker container locally (without the Docker Hub):

```bash
docker-compose up -d
```

If you want to use the Docker Hub image within your existing Docker Compose file you can use the following YAML snippet:

```yaml
sabnzbd:
    image: "sabnzbd/sabnzbd"
    container_name: "sabnzbd"
    volumes:
        - "<datadir path>:/datadir"
        - "<media path>:/media"
    ports:
        - "8080:8080"
    restart: always
```

## Configuration

### Volumes

Please mount the following volumes inside your SABnzbd container:

* `/datadir`: Holds all the SABnzbd data files (e.g. config, postProcessing)
* `/media`: Directory for media (downloaded files)

### Configuration file

By default the SABnzbd configuration is located on `/datadir/config.ini`.
If you want to change this you've to set the `CONFIG` environment variable, for example:

```
CONFIG=/datadir/sabnzbd.ini
```

### UID and GID

By default SABnzbd runs with user ID and group ID `666`.
If you want to run SABnzbd with different ID's you've to set the `SABNZBD_UID` and/or `SABNZBD_GID` environment variables, for example:

```
SABNZBD_UID=1234
SABNZBD_GID=1234
```

## Improvements for SABnzbd version > 0.8

SABnzbd brings a lot of improvements in version `0.8` and greater. This image is built to use those improvements, which means:

* you can use the latest `par2` utility and set _Extra PAR2 Parameters_ in your SABnzbd config switches
  * `-t` for using `par` with multi-core CPUs (see also [this wiki page](http://wiki.sabnzbd.org/configure-switches#multi-core))
  * `-N` to improve failed repairs (see also [this forum thread](http://forums.sabnzbd.org/viewtopic.php?f=2&t=19913#p103827))
* you can use 7Zip to unpack `.7z` archives
