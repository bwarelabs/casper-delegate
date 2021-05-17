# [BwareLabs] Install Casper client and delegate

## ![alt text](/docs/BWARE-icon.png) IMPORTANT NOTICE
**The scripts were tested on Ubuntu 20.04 LTS machines which respect the hardware requirements imposed by CasperLabs as seen [here](https://docs.casperlabs.io/en/latest/node-operator/hardware.html).**

## ![alt text](/docs/BWARE-icon.png) Contents of the main directory
- _.env_ - this contains important environment variables which are needed in order to properly install the Casper client and its prerequisites
  - **USERNAME** - in order to install the Casper client, you should do it with a non-root and non-casper user; this variable will ensure the creation of an user with sudo privileges that will start the installation
  - **HOMEDIR** - home directory of the **${USERNAME}** user
  - **STARTDIR** - start directory of the scripts (basically, full path of the _casper-delegate_ directory as downloaded on your machine)
  - **CASPER_VERSION** - version which should be used (please, follow the [#mainnet-announcements](https://discord.gg/Cb3Gue5V67) or [#testnet-announcements](https://discord.gg/WYsDJpSstr) channels on Discord, according to your usecase, to see the latest updates)
  - **CASPER_NETWORK** - Casper network (_casper_ for **Mainnet** and _casper-test_ for **Testnet**)
- _.delegate_env_ - this contains important environment variables which are needed in order to properly start a delegation request
  - **CASPER_VERSION** - same as above
  - **USERNAME** - same as above
  - **HOMEDIR** - same as above
  - **GAS** - amount of motes (1 CSPR = 10^9 motes) to pay for the delegation request - standard is 3 CSPR (= 3 * 10^9 motes)
  - **AMOUNT** - amount of motes (1 CSPR = 10^9 motes) you wish to delegate - **PAY ATTENTION TO WHAT YOU INPUT**
  - **VALIDATOR_PUBLIC_KEY_HEX** - public key hex of the validator you wish to delegate to - **PAY ATTENTION TO WHAT YOU INPUT**
  - _INTERESTING FACT: THE DEFAULT VALIDATOR_PUBLIC_KEY_HEX FOUND IN THE FILE IS BwareLabs' OWN CASPER VALIDATOR - FEEL FREE TO DELEGATE TO US!_
- _.transfer_env_ - this contains important environment variables which are needed in order to properly start a transfer to another wallet
  - **CASPER_VERSION** - same as above
  - **ID** - transaction ID (type in an integer of your choice so you know this is your transaction)
  - **AMOUNT** - amount of motes (1 CSPR = 10^9 motes) you wish to transfer - **PAY ATTENTION TO WHAT YOU INPUT**
  - **TARGET_PUBLIC_KEY_HEX** - public key hex of the target wallet/account - **PAY ATTENTION TO WHAT YOU INPUT**
  - _INTERESTING FACT: ALL THE TRANSFERS ON THE CASPER BLOCKCHAIN HAVE A STANDARD TRANSACTION FEE OF 10000 MOTES - THIS IS HARDCODED IN THE TRANSFER SCRIPT SO YOU DON'T HAVE TO WORRY ABOUT IT_
- _check_balance.sh_ - main script that checks balance of an account (either from local machine OR by providing a public key hex) - either provide a PUBLIC_KEY_HEX of a known account, or the script will try and find the PUBLIC_KEY_HEX from your local machine
- _install_client_for_delegation.sh_ - main script that starts the installation of the Casper client
- _start_transfer.sh_ - main script that starts a transfer (to a known account)
- _start_delegating.sh_ - main script that starts a delegation request (to a known validator)
- _utils_ - directory which contains helper scripts

## ![alt text](/docs/BWARE-icon.png) Contents of utils directory
- _create_user.sh_ - creates user with **${USERNAME}** name with sudo privileges (if the user with the pointed name doesn't already exist - will require your manual intervention to insert the password for the user)
- _generate_keys.sh_ - generates keypair (if they do not already exist from manual install - it is highly recommended to save your private keys somewhere safe - you will need the public key for creating your account on the blockchain explorer, for receiving staking rewards, etc)
- _install_prerequisites_for_delegation.sh_ - installs main binaries and builds the contracts (will require your manual intervention at some point)

## ![alt text](/docs/BWARE-icon.png) First steps
- Make sure you have git installed on your machine (if not sure, you can run the following command to make sure you have the package installed)
```
sudo apt install git -y 
```
- Clone the git main git repository via HTTPS or SSH (below example is with HTTPS since it's easier, but it is not the recommended way)
```
git clone https://github.com/bwarelabs/casper-delegate.git
```

## ![alt text](/docs/BWARE-icon.png) How to install the Casper client
- Go to casper-delegate directory
```
cd casper-delegate
```
- Carefully complete _.env_ with the appropiate values, depending on your use case (mainnet/testnet, latest version, etc.)
- From the ${START_DIR}, run the following command in your terminal:
```
sudo bash install_client_for_delegation.sh
```
- This can be run as root, the user handling is made inside the scripts
- **IMPORTANT: IN THIS STEP YOU WILL CREATE A KEY PAIR FOR YOUR NEW CSPR ACCOUNT**

## ![alt text](/docs/BWARE-icon.png) How to withdraw CSPR in your account
- In the installation step, you have created a new KEY PAIR, which can be found in _/etc/casper/validator_keys_
```
ls -alt /etc/casper/validator_keys
```
- **IMPORTANT: YOU SHOULD STORE YOUR ACCOUNT INFORMATION (ESPECIALLY YOU PRIVATE KEY) IN A SAFE MANNER**
- You can find the public key for your account in the _/etc/casper/validator_keys/public_key_hex_ file
```
cat /etc/casper/validator_keys/public_key_hex
```
- Your private key is the one stored in _/etc/casper/validator_keys/secret_key.pem_
```
cat /etc/casper/validator_keys/secret_key.pem
```
- You can copy paste the value stored in _/etc/casper/validator_keys/public_key_hex_ in the [Casper Explorer](https://cspr.live) to check your balance
- This address can now be used to withdraw CSPR from your preferred exchange (Coinlist, Huobi, AscendEx, etc) if you want to delegate them to a known validator

## ![alt text](/docs/BWARE-icon.png) How to start a delegation request
- Go to casper-delegate
```
cd casper-delegate
```
- Carefully complete _.delegate_env_ with the appropiate values, depending on your use case (**BE CAREFUL AT THE VALIDATOR PUBLIC KEY**)
- From the ${START_DIR}, run the following command in your terminal:
```
sudo bash start_delegating.sh
```
- This can be run as root, the user handling is made inside the scripts
- **THE DELEGATED AMOUNT SHOULD BE WRITTEN IN MOTES**
- **GAS FEE FOR THIS OPERATION IS 3 CSPR (STANDARD)**

## ![alt text](/docs/BWARE-icon.png) How to start a transfer
- Go to casper-delegate directory
```
cd casper-delegate
```
- Carefully complete _.transfer_env_ with the appropiate values, depending on your use case (**BE CARFEUL AT THE TARGET PUBLIC KEY**)
- From the ${START_DIR}, run the following command in your terminal:
```
sudo bash start_transfer.sh
```
- This can be run as root, the user handling is made inside the scripts
- **THE TRANSFER AMOUNT SHOULD BE WRITTEN IN MOTES**
- **GAS FEE FOR THIS OPERATION IS 10,000 MOTES (STANDARD)**

## ![alt text](/docs/BWARE-icon.png) Contact

For official inquiries, you can contact us at <info@bwarelabs.com>.

For other details, feel free to contact us on **Discord** (_Mateip | bwarelabs.com#1629_, _Silviu | bwarelabs.com#8286_, _Tibi | bwarelabs.com#4803_).

## ![alt text](/docs/BWARE-icon.png) Copyright

Copyright © 2021 [BwareLabs](https://bwarelabs.com/)
- [Telegram](https://t.me/BwareLabsAnnouncements)
- [Twitter](https://twitter.com/BwareLabs)
- [Linkedin](https://www.linkedin.com/company/bwarelabs)

![alt text](/docs/BWARE_yellow_gradient.png)
