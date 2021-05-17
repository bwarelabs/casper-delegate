#!/bin/bash

sudo apt-get update -y
sudo apt install dnsutils -y
sudo apt install jq -y

cd $HOMEDIR
echo "deb https://repo.casperlabs.io/releases" bionic main | sudo tee -a /etc/apt/sources.list.d/casper.list
curl -O https://repo.casperlabs.io/casper-repo-pubkey.asc
sudo apt-key add casper-repo-pubkey.asc
sudo apt update -y
sudo apt install casper-node-launcher -y
sudo apt install casper-client -y

sudo apt purge --auto-remove cmake
wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main'   
sudo apt update -y
sudo apt install cmake -y

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

sudo apt install libssl-dev -y
sudo apt install pkg-config -y
sudo apt install build-essential -y

BRANCH="1.0.20" \
	    && git clone --branch ${BRANCH} https://github.com/WebAssembly/wabt.git "wabt-${BRANCH}" \
	        && cd "wabt-${BRANCH}" \
		    && git submodule update --init \
		        && cd - \
			    && cmake -S "wabt-${BRANCH}" -B "wabt-${BRANCH}/build" \
			        && cmake --build "wabt-${BRANCH}/build" --parallel 8 \
				    && sudo cmake --install "wabt-${BRANCH}/build" --prefix /usr --strip -v \
				        && rm -rf "wabt-${BRANCH}"
wait
git clone git://github.com/CasperLabs/casper-node.git
cd casper-node/
git checkout tags/$(git tag | tail -1)
make setup-rs
wait
make build-client-contracts -j
wait

cd $STARTDIR
