#!/bin/bash

source .env

user_exists(){ id "${USERNAME}" &>/dev/null; } # silent, it just sets the exit code
if user_exists "${USERNAME}"; then  # use the function, save the code
    echo 'User already exists - no need to create another one'
else
    echo 'Creating user with sudo privileges - you will be asked to set the password for this user'
    echo 'Please remember the password - it will be prompted when installing the Casper client'    
    sudo useradd $USERNAME -s /bin/bash -m -g sudo
    sudo echo "$USERNAME ALL=(ALL:ALL) ALL" >> /etc/sudoers
    sudo passwd $USERNAME
fi
