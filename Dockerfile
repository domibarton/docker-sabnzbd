FROM debian:bullseye-20220125-slim

LABEL maintainer="Dominique Barton"

#
# Install python and other required packages (https://github.com/sabnzbd/sabnzbd/blob/master/INSTALL.txt#L58)
#
RUN export DEBIAN_FRONTEND=noninteractive \
    && sed -i "s#deb http://deb.debian.org/debian bullseye main#deb http://deb.debian.org/debian bullseye main non-free#g" /etc/apt/sources.list \
    && apt-get -q update \
    && apt-get install -qqy --no-install-recommends \
      python3-pip \
      python3-openssl \
      p7zip-full \
      par2 \
      unrar \
      unzip \
      python3 \
      openssl \
      ca-certificates \
      build-essential \
      libssl-dev \
      libffi-dev \
      python3-dev \
      cargo \
    && /usr/bin/update-alternatives --install /usr/bin/python python /usr/bin/python3 1

#
# Add SABnzbd init script.
#
COPY sabnzbd.sh /sabnzbd.sh

#
# Fix locales to handle UTF-8 characters.
#
ENV LANG C.UTF-8

#
# Specify versions of software to install.
#
ARG SABNZBD_VERSION=3.5.3

#
# Add (download) sabnzbd
#
ADD https://github.com/sabnzbd/sabnzbd/releases/download/${SABNZBD_VERSION}/SABnzbd-${SABNZBD_VERSION}-src.tar.gz /tmp/sabnzbd.tar.gz

#
# Install SABnzbd and requied dependencies (https://github.com/sabnzbd/sabnzbd/blob/master/INSTALL.txt#L67)
#
RUN export DEBIAN_FRONTEND=noninteractive \
    && groupadd -r -g 666 sabnzbd \
    && useradd -l -r -u 666 -g 666 -d /sabnzbd sabnzbd \
    && chmod 755 /sabnzbd.sh \
    && tar xzf /tmp/sabnzbd.tar.gz \
    && mv SABnzbd-* sabnzbd \
    && python3 -m pip install -r /sabnzbd/requirements.txt \
    && chown -R sabnzbd: sabnzbd \
    && chmod +x /sabnzbd/scripts/Deobfuscate.py \
    && apt-get remove -qy \
      build-essential \
      libssl-dev \
      libffi-dev \
      python3-dev \
      cargo \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* \
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
