#!/bin/sh

# Check environment variables.
if [ -z "$USER_ID" ]; then
	echo "USER_ID not set. Exiting..."
	exit
fi
if [ -z "$GROUP_ID" ]; then
	echo "GROUP_ID not set. Exiting..."
	exit
fi
if [ -z "$USER_NAME" ]; then
	echo "USER_NAME not set. Exiting..."
	exit
fi
if [ -z "$GROUP_NAME" ]; then
	echo "GROUP_NAME not set. Exiting..."
	exit
fi

groupadd -f -g "$GROUP_ID" "$GROUP_NAME"
useradd -G sudo --shell /bin/bash -u "$USER_ID" -g "$GROUP_ID" -o -c "" \
    -m "$USER_NAME"
echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
export HOME=/home/$USER_NAME
export SHELL=/bin/bash

exec gosu "$USER_NAME" "bash"
