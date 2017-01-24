FROM debian:jessie-backports
MAINTAINER Dominique Barton

#
# Create user and group for SABnzbd.
#

RUN groupadd -r -g 666 sabnzbd \
    && useradd -l -r -u 666 -g 666 -d /sabnzbd sabnzbd

#
# Add SABnzbd init script.
#

ADD sabnzbd.sh /sabnzbd.sh
RUN chmod 755 /sabnzbd.sh

#
# Install SABnzbd and all required dependencies.
#

RUN export SABNZBD_VERSION=1.2.0 PAR2CMDLINE_VERSION=v0.6.14 \
    && sed -i "s/ main$/ main contrib non-free/" /etc/apt/sources.list \
    && apt-get -q update \
    && apt-get -t jessie-backports upgrade -qy openssl \
    && apt-get install -qy curl ca-certificates python-cheetah python-yenc unzip unrar p7zip-full build-essential automake \
    && apt-get -t jessie-backports install -qy python-cryptography python-openssl \
    && curl -SL -o /tmp/sabnzbd.tar.gz https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz \
    && tar xzf /tmp/sabnzbd.tar.gz \
    && mv SABnzbd-* sabnzbd \
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

VOLUME ["/datadir", "/media"]

EXPOSE 8080

#
# Start SABnzbd.
#

WORKDIR /sabnzbd

CMD ["/sabnzbd.sh"]
