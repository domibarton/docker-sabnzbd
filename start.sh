#!/bin/sh
cd /sabnzbd
git pull
./SABnzbd.py -b 0 -f /datadir/config.ini
