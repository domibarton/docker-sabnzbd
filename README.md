## About

This is a Docker image for [SABnzbd](http://sabnzbd.org/) - the Open Source Binary Newsreader written in Python.

The Docker image is built for the latest SABnzbd versions, which means:

* running SABnzbd under its __own user__ (not `root`)
* __automatic update__ of SABnzbd on container restart
* instant __switching between SABnzbd versions__
* support of OpenSSL / HTTPS encryption
* support of __RAR archives__
* support of __ZIP archives__
* support of __7Zip archives__ ([with SABnzbd version >= 0.8](#improvements-for-sabnzbd-version--08))
* support of the latest `par2` repair utility ([improved with SABnzbd version >= 0.8](#improvements-for-sabnzbd-version--08))

## Configuration

### Volumes

Mount the following volumes inside your container:

* `<datadir path>:/datadir`
* `<media path>:/media`

### Configuration file

By default the SABnzbd configuration is located on:

```
/datadir/config.ini
```

If you want to change this, set the `CONFIG` environment variable.

### SABnzbd Version

By default the latest SABnzbd version will be used by pointing at the `master` tree of the [SABnzbd git repository](https://github.com/sabnzbd/sabnzbd).
If you want a different version you've set the `VERSION` environment variable to a valid git branch or tag.

_Please note that SABnzbd will automatically be updated when you restart your container._

## Run

### Run via docker CLI

```bash
docker run --name sabnzbd -v <datadir path>:/datadir -v <media path>:/media dbarton/sabnzbd
```

### Run via docker-compose

```yaml
sabnzbd:
    image: "dbarton/sabnzbd"
    container_name: "sabnzbd"
    volumes:
        - "<datadir path>:/datadir"
        - "<media path>:/media"
    tty: true
    stdin_open: true
    restart: always
```

## Improvements for SABnzbd version > 0.8

Please note that there are a lot of improvements in SABnzbd version `0.8` and greater.

This image is built to use these improvements, which means:

* you can use the latest `par2` utility and set _Extra PAR2 Parameters_ in your SABnzbd config switches
  * `-t` for using `par` with multi-core CPUs (see also [this wiki page](http://wiki.sabnzbd.org/configure-switches#multi-core))
  * `-N` to improve failed repairs (see also [this forum thread](http://forums.sabnzbd.org/viewtopic.php?f=2&t=19913#p103827))
* you can use 7Zip to unpack `.7z` archives
