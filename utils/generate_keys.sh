#!/bin/bash

export KEYS_PATH=/etc/casper/validator_keys
if [ -f ${KEYS_PATH}/secret_key.pem -a -f ${KEYS_PATH}/public_key.pem -a -f ${KEYS_PATH}/public_key_hex ]; then
    echo "The keys are already generated - no need to generate new ones"
else
    sudo -u casper casper-client keygen /etc/casper/validator_keys
fi
