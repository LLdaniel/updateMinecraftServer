#!/bin/bash
#######################################################
# Update Minecraft Bedrock (C++)/Java Server on Linux #
#######################################################
function usage(){
    echo "Usage:"
    echo "updateMinecraftServer.sh -o <old_version_tag> [-n <new_version_tag>] [-t <type>]"
    echo '  -n <new_version_tag>    new version tag update to (default will be newest tag)'
    echo '  -t <type>               type "bedrock" for bedrock, type "java" for java server (default "Java")'
    exit 0
}

function update(){
    url=""
    # is new tag specified otherwise take newest server version
    if [[ -z $newtag ]]
    then
	if [[ $servertype == "java" ]]
	then
	    url=https://www.minecraft.net/en-us/download/server
	    newtag=$(curl $url -s -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36' | grep -Eo 'minecraft_server.[0-9,\.]*.jar' -m 1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')
	else
	    url=https://www.minecraft.net/en-us/download/server/bedrock
	    newtag=$(curl $url -s -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36' | grep -Eo 'bedrock-server-[0-9,\.]+' -m 1 | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
	fi
    fi
    
    # main routine
    echo -e "\e[33mUpdating Minecraft $servertype Server\e[0m"
    echo -e "\e[33mCurrent version: $oldtag\e[0m"
    echo -e "\e[33mPlanned version: $newtag\e[0m"

    # Download new version
    echo -e "\e[33mDownloading...\e[0m"
    if [[ $servertype == "bedrock" ]]
    then
	wget -P ~/Downloads https://minecraft.azureedge.net/bin-linux/bedrock-server-$newtag.zip
    else
	# new dynamic variant: mimic a browser call with curl and evaluate the regex with grep:
	download=$(curl $url -s -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36' | grep -Eo 'https://piston-data.mojang.com/v1/objects/.*/server.jar')
	wget -P ~/Downloads ${download}
    fi
    
    # unzip it and remove the download file
    echo -e "\e[33mExtracting...\e[0m"
    if [[ $servertype == "bedrock" ]]
    then
	unzip ~/Downloads/bedrock-server-$newtag.zip -d ~/Desktop/MinecraftBedrock-$newtag/
	rm ~/Downloads/bedrock-server-$newtag.zip
    else
	mkdir -p ~/Desktop/MinecraftJava-$newtag/
	mv ~/Downloads/server.jar ~/Desktop/MinecraftJava-$newtag/

	# for java one has to start the server once
	echo -e "\e[33mOne time start for Minecraft Server\e[0m"
	cd ~/Desktop/MinecraftJava-$newtag/
	java -Xmx4G -Xms1024M -jar server.jar nogui
	echo -e "\e[33mAccepting eula.txt\e[0m"
	sed -i s/false/true/g eula.txt
    fi
    echo -e "\e[33mNew properties file:\e[0m"
    diff -u --color ~/Desktop/Minecraft${servertype^}-$oldtag/server.properties ~/Desktop/Minecraft${servertype^}-$newtag/server.properties
    read -p $'\e[33mAccept to merge properties file manually [y/n]?\e[0m ' SERVPROP
    if [ $SERVPROP == "y" ]
    then
	# copy old files to new server
	echo ""
	echo -e "\e[33mCopying worlds and packs...\e[0m"
	cp ~/Desktop/Minecraft${servertype^}-$oldtag/whitelist.json ~/Desktop/Minecraft${servertype^}-$newtag/
	if [[ $servertype == "bedrock" ]]
	then
	    cp ~/Desktop/Minecraft${servertype^}-$oldtag/permissions.json ~/Desktop/Minecraft${servertype^}-$newtag/
	    cp -r ~/Desktop/Minecraft${servertype^}-$oldtag/worlds ~/Desktop/Minecraft${servertype^}-$newtag/
	    cp -r ~/Desktop/Minecraft${servertype^}-$oldtag/resource_packs/SweetDreamsShader2.0 ~/Desktop/Minecraft${servertype^}-$newtag/resource_packs/
	    cp ~/Desktop/Minecraft${servertype^}-$oldtag/howto.txt ~/Desktop/Minecraft${servertype^}-$newtag/
	else
	    cp ~/Desktop/Minecraft${servertype^}-$oldtag/ops.json ~/Desktop/Minecraft${servertype^}-$newtag/
	    cp ~/Desktop/Minecraft${servertype^}-$oldtag/usercache.json ~/Desktop/Minecraft${servertype^}-$newtag/
	    cp -r ~/Desktop/Minecraft${servertype^}-$oldtag/SandysWorld ~/Desktop/Minecraft${servertype^}-$newtag/
	    cp ~/Desktop/Minecraft${servertype^}-$oldtag/start.sh ~/Desktop/Minecraft${servertype^}-$newtag/
	fi
	### move this manually due to frequent changes
	# cp ~/Desktop/Minecraft${servertype^}-$oldtag/server.properties ~/Desktop/Minecraft${servertype^}-$newtag/
	echo -e "\e[33mUpdate successfull! Reminder: Change properties file manually!\e[0m"
    else
	echo "Update process canceled."
	rm -r ~/Desktop/Minecraft${servertype^}-$newtag/
    fi
}

hasOldTag=false
isH=false
while getopts 'ht:o:n:' OPTION; do
    case "$OPTION" in
	h)
	    isH=true
	    ;;
	
	t)
	    servertype="$OPTARG"
	    if [[ $servertype != "java" ]] && [[ $servertype != "bedrock" ]]
	    then
		echo "Update process canceled. $servertype is not a correct server type."
		exit 1
	    fi
	    
	    ;;
	o)
	    oldtag="$OPTARG"
	    hasOldTag=true
	    ;;
	n)
	    newtag="$OPTARG"
	    ;;
	?)
	usage
	;;
    esac
done
shift "$(($OPTIND -1))"

if ( [[ $OPTIND -eq 1 ]] && ! $isH ) || ! $hasOldTag
then
    usage
else
    update
fi

