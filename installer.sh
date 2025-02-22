#! /bin/bash

read -p $'\n'"This script will build and install XMRig. Continue? ((Y)es / (N)o): " confirm

if [[ !($confirm == [yY] || $confirm == [yY][eE][sS]) ]] then
	echo "Installation canceled"
	exit 1
fi

# Step 1: Get and build repos according to https://xmrig.com/docs/miner/build/ubuntu

echo "Cloning repositories..."
# sudo apt install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
# git clone https://github.com/xmrig/xmrig.git

read -p $'\n'"Do you want the advanced build? ((Y)es / (N)o): " confirm

if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] then
	echo "Advanced build..."
	# mkdir xmrig/build && cd xmrig/scripts
	# ./build_deps.sh && cd ../build
	# cmake .. -DXMRIG_DEPS=scripts/deps
else
	echo " Basic build..."
	# mkdir xmrig/build && cd xmrig/build
	# cmake ..
fi

# make -j$(nproc)

# Step 2: Install to the system

# Create config.json in /usr/var?

echo $'\n'"Finished"
