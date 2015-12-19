#!/bin/sh

echo 'Updating SABnzbd...'
git pull

echo 'Starting SABnzbd...'
exec ./SABnzbd.py -b 0 -f /datadir/config.ini
