#!/bin/sh

if [[ -n "${VERSION}" ]]
then
    echo "Checking out SABnzbd version '${VERSION}'..."
    git checkout ${VERSION}
fi

echo "Updating SABnzbd..."
git pull

CONFIG=${CONFIG:-/datadir/config.ini}
echo "Starting SABnzbd with config '${CONFIG}'..."
exec ./SABnzbd.py -b 0 -f ${CONFIG}
