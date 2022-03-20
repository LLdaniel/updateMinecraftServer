#!/bin/bash
#######################################################
# Update Minecraft Bedrock (C++)/Java Server on Linux #
#######################################################
if [[ "$1" == "--help" ]] || [[ -z "$1" ]]
then
    echo "Usage:"
    echo "updateMinecraftServer.sh <old_version_tag> <new_version_tag> [option]"
    echo '  -t [type]           type "bedrock" for bedrock, type "java" for java server'
else
    if [[ "$4" == "bedrock" ]]
    then
	servertype="Bedrock"
    elif [[ "$4" == "java" ]]
    then
	servertype="Java"
    else
	echo "Update process canceled. $4 is not a correct server type."
    fi
    
    echo -e "\e[33mUpdating Minecraft $servertype Server\e[0m"
    echo -e "\e[33mCurrent version: $1\e[0m"
    echo -e "\e[33mPlanned version: $2\e[0m"

    # Download new version
    echo -e "\e[33mDownloading...\e[0m"
    if [[ $4 == "bedrock" ]]
    then
	wget -P ~/Downloads https://minecraft.azureedge.net/bin-linux/bedrock-server-$2.zip
    else
	# sadly the hash is different for every update, last one was: https://launcher.mojang.com/v1/objects/a16d67e5807f57fc4e550299cf20226194497dc2/server.jar
	# 1.18.2
        wget -P ~/Downloads https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar
    fi
    
    # unzip it and remove the download file
    echo -e "\e[33mExtracting...\e[0m"
    if [[ $4 == "bedrock" ]]
    then
	unzip ~/Downloads/bedrock-server-$2.zip -d ~/Desktop/MinecraftBedrock-$2/
	rm ~/Downloads/bedrock-server-$2.zip
    else
	mkdir -p ~/Desktop/MinecraftJava-$2/
	mv ~/Downloads/server.jar ~/Desktop/MinecraftJava-$2/

	# for java one has to start the server once
	echo -e "\e[33mOne time start for Minecraft Server\e[0m"
	cd ~/Desktop/MinecraftJava-$2/
	java -Xmx4G -Xms1024M -jar server.jar nogui
	echo -e "\e[33mAccepting eula.txt\e[0m"
	sed -i s/false/true/g eula.txt
    fi
    echo -e "\e[33mNew properties file:\e[0m"
    cat ~/Desktop/Minecraft$servertype-$2/server.properties
    read -p $'\e[33mAccept to merge properties file manually [y/n]?\e[0m ' SERVPROP
    if [ $SERVPROP == "y" ]
    then
	# copy old files to new server
	echo ""
	echo -e "\e[33mCopying worlds and packs...\e[0m"
	cp ~/Desktop/Minecraft$servertype-$1/whitelist.json ~/Desktop/Minecraft$servertype-$2/
	if [[ $4 == "bedrock" ]]
	then
	    cp ~/Desktop/Minecraft$servertype-$1/permissions.json ~/Desktop/Minecraft$servertype-$2/
	    cp -r ~/Desktop/Minecraft$servertype-$1/worlds ~/Desktop/Minecraft$servertype-$2/
	    cp -r ~/Desktop/Minecraft$servertype-$1/resource_packs/SweetDreamsShader2.0 ~/Desktop/Minecraft$servertype-$2/resource_packs/
	    cp ~/Desktop/Minecraft$servertype-$1/howto.txt ~/Desktop/Minecraft$servertype-$2/
	else
	    cp ~/Desktop/Minecraft$servertype-$1/ops.json ~/Desktop/Minecraft$servertype-$2/
	    cp ~/Desktop/Minecraft$servertype-$1/usercache.json ~/Desktop/Minecraft$servertype-$2/
	    cp -r ~/Desktop/Minecraft$servertype-$1/SandysWorld ~/Desktop/Minecraft$servertype-$2/
	    cp ~/Desktop/Minecraft$servertype-$1/start ~/Desktop/Minecraft$servertype-$2/
	fi
	### move this manually due to frequent changes
	# cp ~/Desktop/Minecraft$servertype-$1/server.properties ~/Desktop/Minecraft$servertype-$2/
	echo -e "\e[33mUpdate successfull! Reminder: Change properties file manually!\e[0m"
    else
	echo "Update process canceled."
	rm -r ~/Desktop/Minecraft$servertype-$2/
    fi
fi
