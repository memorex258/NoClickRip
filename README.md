# NoClickRip

A 0 click media ripper for Linux. Currently just a dump of my poorly written 
bash script that runs when I put a disk in my DVD drive. Feel free to use this
as the basis for your own scripts, but the eventual goal is to have this as an 
installable package from a repository. Currently only does DVD films, but the plan
is to also do TV shows from DVDs, and music too. 


# Dependencies

I have no idea what the full list of dependencies are. I just installed things 
as and when I needed them, so I'm not sure what's required to run this. The few 
I'm pretty sure on are: 

* HandBrakeCLI
* dvdbackup
* lsdvd
* udisks-glue (to run the script after mounting)

### Notify
The references to notify are for a different script I wrote that sends push 
notifications to my phone, so I know when things are done. Either add your
own notify script, or comment those lines out. 


# Road Map
In no particular order, the bits I still want to get added are:

* Clean up after encoding has finished
* Reliably detect if a DVD is a film or series
* If a series DVD is entered, work out what it is, and where to put the files. 
* Rip music CDs
* Potentially rewrite it in a nicer language, and make it run as a proper application,
rather than one script per DVD. 
* Add better queuing support. 
* Configuration file in users home dir instead of at the top of the script
* Ability to pass options in


## Attribution
This script is a result of pulling together lots of peoples suggestions that I 
found on various forums, as well as my own pieces. I don't remember who or where 
I got all the pieces  from, but if something in here looks like something you 
wrote online somewhere, sometime, then thanks. 