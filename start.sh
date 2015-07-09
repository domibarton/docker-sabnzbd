#!/bin/sh
cd /sabnzbd
git pull
./SABnzbd.py -f /sabnzbd/config.ini
