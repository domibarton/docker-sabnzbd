## Build

```bash
git clone https://github.com/confirm-it-solutions/docker-sabnzbd.git
cd docker-sabnzbd
docker build -t <tag> .
```

## Run

```bash
docker run --name sabnzbd -v <datadir path>:/datadir -v <media path>:/media confirm/sabnzbd
```
