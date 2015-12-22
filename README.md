## About

This is a Docker image for [SABnzbd](http://sabnzbd.org/) - the Open Source Binary Newsreader written in Python.

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