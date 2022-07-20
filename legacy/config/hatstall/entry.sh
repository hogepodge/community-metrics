#!/bin/bash
echo "Running Hatstall"

sudo chown -R grimoirelab grimoirelab-hatstall

# pull database password from environment
sudo sed -e "s/MYSQL_ROOT_PASSWORD/$MYSQL_ROOT_PASSWORD/g" \
    shdb.tmpl > shdb.cfg

source ./stage
