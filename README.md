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

The default location is `~/Desktop`.

Attention: Due to changes in the properties file I decided not to overwrite the properties file. I normally adjust them manually.

## Usage
When starting the script you need to specify the previous version tag and the version tag you want to update to.
Just start the script with option `-t` and choose the minecraft server type: bedrock or java.

For examaple you can do:

`./updateMinecraftServer 1.1 2.0 -t bedrock`

or

`./updateMinecraftServer --help`

## Modify the script
Please feel free to modify the script and add more files and directories you use for your server or change the installation directory. This is just a basic sketch how I update my two servers.
