# updateMinecraftServer
A small bash script to update minecraft bedrock and java server. It will transfer the following folders and files to your new version directory:

##### Bedrock
* world
* permission.json
* ressource packs

##### Java
* world
* ops.json
* usercache.json

The default location for the server is `~/Desktop` and the default download directory is `~/Downloads`.

Attention: Due to changes in the properties file I decided not to overwrite the properties file. I normally adjust them manually.

##### Note on Minecraft Launcher
It seems that currently there is no direct source for the java `server.jar` anymore. Therefore the GitHub action supports a time scheduled start of the Minecraft Launcher in order to retrieve the latest java version and `sha1` hash (see `java_version_latest.json`).

## Usage
When starting the script you need to specify the previous version tag. The new version tag is optional.
Just start the script with option `-t` and choose the minecraft server type: bedrock or java.

For examaple you can do:

`./updateMinecraftServer -o 1.1 -t bedrock`

or

`./updateMinecraftServer --help`

## Modify the script
Please feel free to modify the script and add more files and directories you use for your server or change the installation directory. This is just a basic sketch how I update my two servers.
