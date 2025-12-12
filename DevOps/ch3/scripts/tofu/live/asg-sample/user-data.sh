#!/usr/bin/env bash
set -e
sudo su - app-user -c "
  pm2 start /home/app-user/app.config.js && \
  pm2 save
"
