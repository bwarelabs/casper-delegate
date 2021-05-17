#!/bin/bash

# Version: DELTA 11

# Check input balance
# Requirements: 'apt install jq'
# Instruction:  'check_balance.sh <PUBLIC_KEY_HEX>'

source .env

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

export KEYS_PATH=/etc/casper/validator_keys
if [ ! -f ${KEYS_PATH}/secret_key.pem -a ! -f ${KEYS_PATH}/public_key.pem -a ! -f ${KEYS_PATH}/public_key_hex ]; then
    echo "Casper-client keys not located in /etc/casper/validator_keys."
    read -p "Please input directory of casper-keys: " KEYS_PATH
fi

public_hex_path="${KEYS_PATH}/public_key_hex"
echo $public_hex_path
INPUT_HEX="$1"


KNOWN_ADDRESSES=$(sudo -u casper cat /etc/casper/$CASPER_VERSION/config.toml | grep known_addresses)
KNOWN_VALIDATOR_IPS=$(grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' <<< "$KNOWN_ADDRESSES")
IFS=' ' read -r TARGET_HOST _REST <<< "$KNOWN_VALIDATOR_IPS"
echo "This is a known validator IP: $TARGET_HOST"

function getPublicHex() {

    AutoHEX=$(cat "$public_hex_path")

    if [ -z "$INPUT_HEX" ]; then
        INPUT_HEX="$AutoHEX"
        echo && echo -e "${RED}No valid manual input detected !${NC}" && echo
        echo -e "Using public HEX from: ${RED}$public_hex_path${NC}"
    fi

}

function checkBalance() {

echo && echo -e "${CYAN}Input HEX: ${GREEN}$INPUT_HEX${NC}" && echo

LFB=$(curl -s http://$TARGET_HOST:8888/status | jq -r '.last_added_block_info | .height')
echo -e "${CYAN}Chain height: ${GREEN}$LFB${NC}" && echo

LFB_ROOT=$(casper-client get-block  --node-address http://$TARGET_HOST:7777 -b "$LFB" | jq -r '.result | .block | .header | .state_root_hash')
echo -e "${CYAN}Block ${GREEN}$LFB ${CYAN}state root hash: ${GREEN}$LFB_ROOT${NC}" && echo

PURSE_UREF=$(casper-client query-state --node-address http://$TARGET_HOST:7777 -k "$INPUT_HEX" -s "$LFB_ROOT" | jq -r '.result | .stored_value | .Account | .main_purse')
echo -e "${CYAN}Main purse uref: ${GREEN}$PURSE_UREF${NC}" && echo

BALANCE=$(casper-client get-balance --node-address http://$TARGET_HOST:7777 --purse-uref "$PURSE_UREF" --state-root-hash "$LFB_ROOT" | jq -r '.result | .balance_value')
echo -e "${CYAN}Input balance: ${GREEN}$BALANCE${NC}" && echo

}

getPublicHex

checkBalance
