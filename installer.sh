#! /bin/bash

read -p $'\n'"This script will build and install XMRig. Continue? ((Y)es / (N)o): " confirm

if [[ !($confirm == [yY] || $confirm == [yY][eE][sS]) ]] then
	echo "Installation canceled"
	exit 1
fi

# Step 1: Get and build repositories according to https://xmrig.com/docs/miner/build/ubuntu

echo "Cloning repositories..."
sudo apt install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
git clone https://github.com/xmrig/xmrig.git

read -p $'\n'"Do you want the advanced build? ((Y)es / (N)o): " confirm

if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] then
	echo "Advanced build..."
	mkdir xmrig/build && cd xmrig/scripts
	./build_deps.sh && cd ../build
	cmake .. -DXMRIG_DEPS=scripts/deps
else
	echo " Basic build..."
	mkdir xmrig/build && cd xmrig/build
	cmake ..
fi

make -j$(nproc)

cd ../../

# Step 2: Install to the system
# Copy binary and create config.json in /usr/local/bin

read -p $'\n'"Create new config? ((Y)es / (N)o): " confirm

if [[ !($confirm == [yY] || $confirm == [yY][eE][sS]) ]] then
	echo $'\n'"Finished"
	exit 0
fi

# Create config file
read -p "Mining pool URL: " poolurl
read -p "Wallet address: " walletaddress

echo "{" >> config.json
echo $'\t'"\"autosave\": true," >> config.json
echo $'\t'"\"cpu\": true," >> config.json
echo $'\t'"\"opencl\": false," >> config.json
echo $'\t'"\"cuda\": false," >> config.json
echo $'\t'"\"pools\": [" >> config.json
echo $'\t\t'"{" >> config.json
echo $'\t\t\t'"\"url\": \"$poolurl\"," >> config.json
echo $'\t\t\t'"\"user\": \"$walletaddress.worker0\"," >> config.json
echo $'\t\t\t'"\"pass\": \"x\"," >> config.json
echo $'\t\t\t'"\"keepalive\": true," >> config.json
echo $'\t\t\t'"\"tls\": true" >> config.json
echo $'\t\t'"}" >> config.json
echo $'\t'"]" >> config.json
echo "}" >> config.json

echo $'\n'"Finished"
