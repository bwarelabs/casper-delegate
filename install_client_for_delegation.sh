#!/bin/bash

source .env

sudo bash utils/create_user.sh
sudo -u ${USERNAME} bash utils/install_prerequisites_for_delegation.sh
sudo -u ${USERNAME} bash utils/generate_keys.sh

sudo -u casper /etc/casper/pull_casper_node_version.sh $CASPER_NETWORK.conf $CASPER_VERSION
sudo -u casper /etc/casper/config_from_example.sh $CASPER_VERSION
