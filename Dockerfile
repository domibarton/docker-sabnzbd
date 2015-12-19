FROM debian:8
MAINTAINER Dominique Barton

RUN sed -i "s/ main$/ main contrib non-free/" /etc/apt/sources.list \
    && apt-get -q update \
    && apt-get install -qy git python-cheetah python-openssl unzip unrar par2 \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

RUN groupadd -r -g 666 sabnzbd \
    && useradd -r -u 666 -g 666 sabnzbd

RUN git clone https://github.com/sabnzbd/sabnzbd.git /sabnzbd \
    && chown -R sabnzbd: /sabnzbd

ADD start.sh /start.sh
RUN chown sabnzbd: /start.sh \
    && chmod 755 /start.sh

VOLUME ['/datadir', '/media']

EXPOSE 8080

USER sabnzbd

WORKDIR /sabnzbd
CMD /start.sh
