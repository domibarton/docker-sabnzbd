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
# Fix locales to handle UTF-8 characters.
#

ENV LANG C.UTF-8

#
# Specify versions of software to install.
#
ARG SABNZBD_VERSION=2.3.9
ARG PAR2CMDLINE_VERSION=v0.6.14-mt1

#
# Install SABnzbd and all required dependencies.
#

RUN export DEBIAN_FRONTEND=noninteractive \
    && export BUILD_PACKAGES="automake build-essential curl python-dev python-pip" \
    && export RUNTIME_BACKPORTS_PACKAGES="openssl python-cryptography python-openssl" \
    && export RUNTIME_PACKAGES="ca-certificates p7zip-full python-cheetah python-yenc unrar unzip libgomp1" \
    && export PIP_PACKAGES="sabyenc" \
    && sed -i "s/ main$/ main contrib non-free/" /etc/apt/sources.list \
    && apt-get -q update \
    && apt-get install -qqy $BUILD_PACKAGES $RUNTIME_PACKAGES \
    && apt-get -t jessie-backports install -qqy $RUNTIME_BACKPORTS_PACKAGES \
    && pip install $PIP_PACKAGES \
    && curl -SL -o /tmp/sabnzbd.tar.gz https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz \
    && tar xzf /tmp/sabnzbd.tar.gz \
    && mv SABnzbd-* sabnzbd \
    && chown -R sabnzbd: sabnzbd \
    && curl -o /tmp/par2cmdline-mt.tar.gz https://codeload.github.com/jkansanen/par2cmdline-mt/tar.gz/${PAR2CMDLINE_VERSION} \
    && tar xzf /tmp/par2cmdline-mt.tar.gz -C /tmp \
    && cd /tmp/par2cmdline-* \
    && aclocal \
    && automake --add-missing \
    && autoconf \
    && ./configure \
    && make \
    && make install \
    && apt-get -y remove --purge $BUILD_PACKAGES \
    && apt-get -y autoremove \
    && apt-get install -qqy $RUNTIME_PACKAGES \
    && apt-get -t jessie-backports install -qqy $RUNTIME_BACKPORTS_PACKAGES \
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
