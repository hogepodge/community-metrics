#!/bin/bash

HOME_DIR='/home/bitergia'
CONF_DIR="$HOME_DIR/conf"

rm -f /tmp/.mordred_healthcheck

sed -e "s/GITHUB_API_TOKEN/$GITHUB_API_TOKEN/g" \
    /home/bitergia/conf/setup.cfg.tmpl > /home/bitergia/conf/setup.cfg
sed -i -e "s/SORTINGHAT_PASSWORD/$SORTINGHAT_PASSWORD/g" \
    /home/bitergia/conf/setup.cfg
sed -i -e "s/MYSQL_ROOT_PASSWORD/$MYSQL_ROOT_PASSWORD/g" \
    /home/bitergia/conf/setup.cfg

cat /home/bitergia/conf/setup.cfg

sirmordred -c $HOME_DIR/conf/setup.cfg
