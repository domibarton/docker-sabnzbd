FROM debian:8
MAINTAINER Dominique Barton

RUN sed -i "s/ main$/ main contrib non-free/" /etc/apt/sources.list \
    && apt-get -q update \
    && apt-get install -qy git python-cheetah python-openssl unzip unrar p7zip-full build-essential automake \
    && git clone https://github.com/Parchive/par2cmdline.git /tmp/par2cmdline \
    && cd /tmp/par2cmdline \
    && aclocal \
    && automake --add-missing \
    && autoconf \
    && ./configure \
    && make \
    && make check \
    && make install \
    && apt-get -y remove build-essential automake \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && cd / \
    && rm -rf /tmp/*

RUN groupadd -r -g 666 sabnzbd \
    && useradd -r -u 666 -g 666 -d /sabnzbd sabnzbd

RUN git clone -b master https://github.com/sabnzbd/sabnzbd.git /sabnzbd \
    && chown -R sabnzbd: /sabnzbd

ADD start.sh /start.sh
RUN chown sabnzbd: /start.sh \
    && chmod 755 /start.sh

VOLUME ["/datadir", "/media"]

EXPOSE 8080

USER sabnzbd

WORKDIR /sabnzbd
CMD ["/start.sh"]
