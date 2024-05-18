#!/bin/bash
##############################################################
# Start Minecraft Launcher to get newest java server version #
##############################################################
# get minecraft launcher
wget https://launcher.mojang.com/download/Minecraft.tar.gz
tar -xvzf Minecraft.tar.gz
if [ -d "$HOME/.minecraft" ]
then
    echo -e "\e[33mClearing launcher directory...\e[0m"
    rm -r $HOME/.minecraft
fi

# start launcher to download newest version
timeout -s SIGKILL 20s ./minecraft-launcher/minecraft-launcher
newtag=$(ls $HOME/.minecraft/versions/ | grep -E "^[0-9\.]+$")
sha1hash=$(cat $HOME/.minecraft/versions/${newtag}/${newtag}.json | grep -Eo '"server": {"sha1": "[0-9,a-z]+"' | cut -d: -f3 | xargs)

# write new version .json
cat <<EOF > java_version_latest.json
{
"version":"$newtag"
"sha1":"  $sha1hash"
}
EOF
