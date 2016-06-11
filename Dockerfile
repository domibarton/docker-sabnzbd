FROM debian:8
MAINTAINER Dominique Barton

#
# Create user and group for SABnzbd.
#

RUN groupadd -r -g 666 sabnzbd \
    && useradd -r -u 666 -g 666 -d /sabnzbd sabnzbd

#
# Add SABnzbd init script.
#

ADD sabnzbd.sh /sabnzbd.sh
RUN chmod 755 /sabnzbd.sh

#
# Install SABnzbd and all required dependencies.
#

RUN export SABNZBD_VERSION=1.0.3 PAR2CMDLINE_VERSION=v0.6.14 \
    && sed -i "s/ main$/ main contrib non-free/" /etc/apt/sources.list \
    && apt-get -q update \
    && apt-get install -qy curl ca-certificates python-cheetah python-openssl python-yenc unzip unrar p7zip-full build-essential automake \
    && curl -o /tmp/sabnzbd.tar.gz https://codeload.github.com/sabnzbd/sabnzbd/tar.gz/${SABNZBD_VERSION} \
    && tar xzf /tmp/sabnzbd.tar.gz \
    && mv sabnzbd-* sabnzbd \
    && chown -R sabnzbd: sabnzbd \
    && curl -o /tmp/par2cmdline.tar.gz https://codeload.github.com/Parchive/par2cmdline/tar.gz/${PAR2CMDLINE_VERSION} \
    && tar xzf /tmp/par2cmdline.tar.gz -C /tmp \
    && cd /tmp/par2cmdline-* \
    && aclocal \
    && automake --add-missing \
    && autoconf \
    && ./configure \
    && make \
    && make install \
    && apt-get -y remove curl build-essential automake \
    && apt-get -y autoremove \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && cd / \
    && rm -rf /tmp/*

#
# Define container settings.
#

VOLUME ["/datadir", "/download"]

EXPOSE 8080

#
# Start SABnzbd.
#

WORKDIR /sabnzbd

CMD ["/sabnzbd.sh"]
