# updateMinecraftServer
A small bash script to update minecraft bedrock and java server. It will transfer the following folders and files to your new version directory:
* world
* whitelist
* permission
* ressource packs

Attention: Due to changes in the properties file I decided not to overwrite the properties file. I normally adjust them manually.

## usage
When starting the script you need to specify the previous version tag and the version tag you want to update to.
just start the script with option `-t` and choose the minecraft server type: bedrock or java.

For examaple you can do:

`./updateMinecraftServer 1.1 2.0 -t bedrock`
