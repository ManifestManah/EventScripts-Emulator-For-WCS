# [Modified EventScripts Emulator Package For WC:S]
This is an altered version of Ayuto's EventScripts Emulator. 
This version has been and will continue to be modified in ways that best support the Warcraft-Source version released by ThaPwned.
The package includes:
- Fixes & Changes the normal EventScripts Emulator doesn't have.
- Extra Fixes that address and solve many of the issues known to negatively affect with the WC:S mod. 
- Extra available commands that are used by various WC:S content. 
 
- A config file containing multiple cvars that will solve issues known to negatively affect the WC:S mod.
- A config file containing the correct plugin and addon loading order.

- Texture materials used for Visual Effects by various WC:S content.
- Sound files (Mp3 format) used for Sound Effects by various WC:S content.
- A SourceMod based auto-download & precaching system for the custom content mentioned above.



## Requirements
For this package to work, it is required that you first install the following:
- [SourceMod](https://www.sourcemod.net/downloads.php)
- [EventScripts-Emulator](https://github.com/Ayuto/EventScripts-Emulator)
- [Warcraft-Source](https://github.com/ThaPwned/WCS)



## Step-by-step installation guide
1. Go to your csgo or cstrike directory (NOTE! Some servers name this directory the server's IP instead).

2. Drag and drop the four folders named: "addons", "cfg", "materials", and "sound" in to the directory.

3. Now go in to your csgo/cfg directory.

4. Copy all the contents found within the autoexec_wcs.cfg and put it in the top of your autoexec.cfg. (If you don't have an autoexec.cfg then simply rename autoexec_wcs.cfg to autoexec.cfg)

5. Copy all the contents found within the server_wcs.cfg and put it inside of your server.cfg.

6. Now restart your server, a server restart is necessary a reload won't do. 
   OBS: The first time you restart your server after adding the Emulator to it you will have to restart the server twice to fully work.



##Requirements
1.1 Source-Python - Can be downloaded here: http://forums.sourcepython.com/

2.1 Warcraft-Source(https://github.com/ThaPwned/WCS)

2.2 SourceMod(https://www.sourcemod.net/downloads.php)

3.1 This step is only if you are running a Windows Server, elsewise ignore this part: 
   ``Visual C++ Redistributable for Visual Studio 2015`` the 32 bit version must be installed.
    Can be downloaded here: https://www.microsoft.com/en-US/download/details.aspx?id=48145



## Bug Reports, Problems & Help
Should you encounter a bug or an issue then please report it in our [Discord's](https://discord.gg/2DnAXkF) bug channel, then we'll look in to it, find a solution and include it in an update.
If you're having trouble installing the package, you can also get assistance in our [Discord](https://discord.gg/2DnAXkF).



## Development Status
Most of the work is already done. The following is a list of things that need to be done.

1.1 [General]				Add the possibility to unload the emulator.
1.2 [General]				Do extensive testings
2.1 [Python]				Implement es.forcevalue() - Revisit CS:GO implementation
2.2 [Python]				Implement es.old_mexec()
2.3 [Python]				Implement es.physics('start', ...)
2.4 [Python]				Implement es.regexec()
3.1 [ES:S]					Implement pycmd_register
4.1 [Console variables]		Implement mattie_eventscripts
4.2 [Console variables]		Implement eventscripts_debug_showfunctions
4.3 [Console variables]		Implement mattie_python
5.1 [Bug Fixing] 			Implement any bugs / issue fixes that gets reported or posted.



##Some Additional Side Notes
1. You can also use the EventScripts API in Source.Python plugins.

2. Unlike EventScripts this emulator also supports CS:GO.
   Though, es.usermsg()/es_usermsg is not supported. Instead please use the usermsg library directly.

3. Ayuto took the original EventScripts libraries from the latest release and adapted them to work with Python 3.
   Ayuto have also removed the example addons like ``mugmod`` or ``slingshot`` to keep it simple.

4. Some differences from the original EventScripts version:
   A possible crash has also been fixed when using handles.
   es.getuserid() also works with SteamID3. 



##Credits
A Big thank you to Ayuto for creating and sharing the original EventScripts-Emulator with the rest of the community.
The original version which has not been modified specifically with WC:S in mind can be found here: https://github.com/Ayuto/EventScripts-Emulator 
