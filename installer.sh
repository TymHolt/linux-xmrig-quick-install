#! /bin/bash

function cancel() {
	echo $'\n'"Installation canceled"
	exit 1
}

function notifyFinished() {
	echo $'\n'"Installation finished"
}

# Ask for confirmation to procede
read -p $'\n'"This script will build and install XMRig. Continue? ((Y)es / (N)o): " vconfirm

if [[ !(${vconfirm,,} = "y" || ${vconfirm,,} = "yes") ]] then
	cancel
fi

# Ask for build option
echo $'\n'"Build options:"
echo "(1) Basic build"
echo "(2) Advanced build"
echo "(3) Cancel..."
read -p $'\n'"Select build option: " vbuildoption

if [[ ${vbuildoption,,} = "basic build" || ${vbuildoption,,} = "basic" ]]; then
	$vbuildoption = "1"
fi

if [[ ${vbuildoption,,} = "advance build" || ${vbuildoption,,} = "advanced" ]]; then
	$vbuildoption = "2"
fi

if [[ !($vbuildoption = "1" || $vbuildoption = "2") ]]; then
	cancel
fi

# Ask for config
read -p $'\n'"Create new config? ((Y)es / (N)o): " vcreateconfig

if [[ ${vcreateconfig,,} = "y" || ${vcreateconfig,,} = "yes" ]]; then
	# Create config file
	read -p "Mining pool URL: " vpoolurl
	read -p "Wallet address: " vwalletaddress
fi

# Get and build repositories according to https://xmrig.com/docs/miner/build/ubuntu
echo "Cloning repositories..."
sudo apt install git build-essential cmake libuv1-dev libssl-dev libhwloc-dev
git clone https://github.com/xmrig/xmrig.git

if [[ $vbuildoption = "2" ]]; then
	echo "Advanced build..."
	mkdir xmrig/build && cd xmrig/scripts
	./build_deps.sh && cd ../build
	cmake .. -DXMRIG_DEPS=scripts/deps
else
	echo "Basic build..."
	mkdir xmrig/build && cd xmrig/build
	cmake ..
fi

make -j$(nproc)

# Create config (if selected)
if [[ ${vcreateconfig,,} = "y" || ${vcreateconfig,,} = "yes" ]]; then
	echo "Creating config..."
	echo "{" >> config.json
	echo $'\t'"\"autosave\": true," >> config.json
	echo $'\t'"\"cpu\": true," >> config.json
	echo $'\t'"\"opencl\": false," >> config.json
	echo $'\t'"\"cuda\": false," >> config.json
	echo $'\t'"\"pools\": [" >> config.json
	echo $'\t\t'"{" >> config.json
	echo $'\t\t\t'"\"url\": \"$vpoolurl\"," >> config.json
	echo $'\t\t\t'"\"user\": \"$vwalletaddress.worker0\"," >> config.json
	echo $'\t\t\t'"\"pass\": \"x\"," >> config.json
	echo $'\t\t\t'"\"keepalive\": true," >> config.json
	echo $'\t\t\t'"\"tls\": false" >> config.json
	echo $'\t\t'"}" >> config.json
	echo $'\t'"]" >> config.json
	echo "}" >> config.json
fi

# Ask to install to system
# Copy binary and config.json to /usr/local/bin

# Return to original directory
cd ../../
notifyFinished