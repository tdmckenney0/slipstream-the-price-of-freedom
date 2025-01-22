# Slipstream: The Price of Freedom

A mod for Homeworld 2 Classic. Set in the Slipstream universe.

## The _Slipstream_ Universe

_Slipstream_ is an alternative _Homeworld_ universe where the in-game events of _Homeworld_, _Homeworld: Deserts of Kharak_, and _Homeworld: Cataclysm_/_Emergence_, along with the contents of their manuals, are considered canon, while other entries in the franchise, such as _Homeworld 2_, _Homeworld 3_, _Homeworld Mobile_, and other future entries, are **not** considered canon. 

### Introduction

Many years after the events of _Homeworld: Cataclysm/Emergence_, the final remnants of the subversion entity known as The Beast were finally defeated. However, the toll upon the galactic political order was beyond cataclysmic, plunging the galaxy into a long and terrible dark age. With the collapse of the remaining rump states of the Taiidan Empire in the wake of the The Beast, the once heavily patrolled suburbs of the galaxy near the Kashmin Sea and Shamal Clusters have become overrun with Vaygr nomads and other pirate races; in only a few years time, the Vaygr have occupied most of the territory held by the former Taiidan empire. The Vaygr impressed their feudal system onto their conquered territories; those subjugated become vassals, and economically plundered for conquests elsewhere. Those ignored by the Vaygr have turned inward to avoid any attention from pirates or warlords. As for the wise and enigmatic Bentusi, those that didn't flee the galaxy were either consumed by the Beast, or hunted to extinction.

With the Vaygr too busy infighting over the spoils of war, Hiigara, largely unscathed, consolidates its power. Uneager to expand or explore an increasingly hostile galaxy while still struggling to rebuild their lost civilization, the Daiamid decides to pull back to its core territorial possessions around the Homeworld system. With its navy spread thin from its battles with the Beast infection, the consequences of the situation were laid bare: Off-world super capital ship production was a massive security risk versus the effectiveness carrier groups with super capital escorts demonstrated against the Beast infection. It was clear to the Daiamid that mothership class vessels just weren't worth the risk to deploy away from the Homeworld where they could easily be captured or destroyed by the increasingly hostile pirate forces of the galaxy. The Daiamid has instead opted to expand existing planet-side manufacturing on both Hiigara and nearby Hiigaran-controlled planets. 

### _Slipstream Research Initiative_ (SRI)

During the eradication of The Beast, naturally-occurring Slipgates were encountered in the more fringe regions of the galaxy. Further exploration of these areas of the galaxy found artificial Slipgates with striking similarities to Bentusi technology, whom unfortunately were no longer around to explain their operation. However, the other half of the Daiamid's plan involved advancing Hiigaran hyperspace technology so that newly constructed ships could be delivered directly to operational theatres. The _Slipstream Research Initiative_ (SRI) was created to research these slipgates, and if possible, reverse engineer the technology the Bentusi used to harness them. SRI would eventually develop the first generation of Slipstream drives, which are must faster and more efficient than the standard quantum waveform hyperdrive. This technology was kept exclusive to the Hiigarans, who often used it as a bargaining chip, until it was much more beneficial to trade inferior versions of the technology to the Vaygr for access to the former Bentusi regions of the galaxy. 

The Daiamid is not exactly content with this arrangement, and frankly, neither are the various Vaygr warlords who simply want to conquer Hiigara and plunder it for themselves. However, the conquest of Hiigaran space would be extremely resource intensive and would require cooperation among the various factions of Vaygr, whom are constantly warring with each other over territory, and whom also see the Hiigarans as subdued and contained for now. It is SRI's obligation to share any discoveries made within Vaygr territory with them, but the Vaygr know that the Hiigarans do most of the advanced research work deep within their own territory, and have a better chance of reverse-engineering the occasional stray Hiigaran vessel. The benefits of this deal, and the Daiamid's reluctance to challenge the Vaygr directly, have left SRI to operate mostly without oversight deep within the more fringe regions of the galaxy where even the Vaygr do not want to venture.

### The Price of Freedom
This political conundrum has been referred to as "the price of freedom" within the Daiamid chamber; A cold war locking themselves and the Vaygr in a perpetual staring contest until one of them blinks. Until that happens, both factions are under pressure to quickly gather resources and strengthen their forces without the other noticing. This has lead to an extremely tense and lawless borderland between the two factions, where entire fleets go missing in action; of course, destroyed in skirmishes that go completely ignored unless politically convenient. Though, that hasn't stopped the persistent and militarily minded from trying to secure resources and strategic positions in the region without repercussion. This is the true "Price of Freedom": deadlocked political machines fighting an unofficial war with no end in sight... 

## Requirements

Homeworld 2 v2.1 or greater is required to play _Slipstream: The Price of Freedom_. This version can be found in the Homeworld Remastered Collection; unfortunately, the original retail CD release is no longer supported as of v4.0. Minimum hardware required: 4gb of RAM, a dual-core CPU, and a modern GPU.

## Getting Started

### Steam

If you're using the Steam version of Homeworld Remastered, it is recommended to install TPOF from the Steam workshop. Once installed: 

1. Launch Homeworld Remastered 
2. Select "Mods" in the launcher 
3. Select "HW2 Classic"
4. Highlight "Slipstream: The Price of Freedom"
5. Press "Select"
6. Add Your command line arguments
7. Press "Launch"

### Non-Steam (GoG, etc)

1. Download the `.big` file from Moddb or Github.
2. Locate the your Homeworld Remastered installation directory.
3. Place the `.big` file in the `Homeworld2Classic\Data` directory.
4. Enter the `Homeworld2Classic\Bin\Release` directory.
5. Create a new shortcut to `Homeworld2.exe` named `Slipstream: The Price of Freedom`
6. Open the properties of this new shortcut.
7. In the Shortcut tab, locate the "Target" box.
8. After the `Homeworld2.exe"`, append ` -mod <name of .big file>`; e.g. `"C:\Games\Homeworld Remastered\Homeworld2Classic\Bin\Release\Homeworld2.exe" -mod TPOFv4.0.big`
9. Add any additional command line parameters.
10. Click the "OK" button.
11. Move the shortcut to the desktop, or wherever you'd like to place it.
12. Double click the shortcut to launch the mod.

## Features

### Multiplayer

When Gearbox re-released Homeworld 2 Classic, they disabled the multiplayer option in the main menu. TPOF restores this option, and allows the player to choose between **Direct Connection** and **Local Area Network (LAN)**; Steam multiplayer is not officially implemented with Homeworld 2 classic, so it has been disabled.

#### Local Area Network (LAN)

LAN multiplayer has been tested with TPOF on both Windows 7 and Windows 11, and is firmly in the "seems to work fine" category, however your mileage may vary. This mode can be also used over the internet via a virtual private network (VPN) tunnel. LAN multiplayer is the preferred connection method to play TPOF. 

#### Direct Connection

Direct Connection multiplayer can be used to directly connect to another network across the internet. For this method to work on modern networks, the following **UDP** ports need to be forwarded from the host's local network router or gateway to the machine TPOF is going to be running on: `6073`,`6500`,`13139`, and port range `2302` to `2400`. When joining a game, enter the host network's public IP address into the connection box, and click join. This method has also been tested on Windows 11, and "seems to work fine".

### Gameplay

Though using the same game engine and assets, _Slipstream: The Price of Freedom_ is very different from Homeworld 2. Emphasis on fleet building and long-term strategy has been heavily reduced in favor of fast-paced tactical gameplay with a focus on combat.

#### Music

Based on your selection at the game setup screen, pressing the F1 key will allow you to skip through your chosen soundtrack.

##### Soundtrack

TPOF includes an original soundtrack by myself and DJZ4K; choose "Shuffle Slipstream" at Game Setup to hear the full soundtrack! Tracks are also included in other playlists alongside the existing Homeworld 2 soundtrack.

#### Hyperspace (Slipstream)

Hiigaran and Vaygr capital ships are now equipped with Slipstream drives that make hyperspace fast and free. Strikecraft and Platforms can now be delivered to the battlefield via ships equipped with a Hyperspace Module.

#### Strikecraft

Strikecraft (Fighters, Corvettes) are faster, more evasive, and break formation often when attacking. Strikecraft are also now capable of being deployed via hyperspace when near a larger ship equipped with a Hyperspace Module subsystem. 

#### Platforms

Platforms can now be moved multiple times, delivered via hyperspace using a module, and also issued guard orders. However, they are slow, weakly armored, and do not engage enemies outside of range. A useful strategy is to have platforms accompany strikecraft when being deployed via hyperspace; Platforms will provide covering fire long enough for strikecraft to get up to speed and scatter.

#### Subsystems

Subsystems have been added and existing ones modified.

##### Advanced Sensors Array

Now grants sensors ping ability to ships with advanced sensors equipped.

##### Weapons

Some Super-Capital ships can build and change weapon turrets, allowing the player to configure a ship for a specific engagement style. 

## Levels

### As-Sirat

> The Bentusi once guided travelers between these two Slipgates for those lost in the nebula do not return...

**As-Sirat** is a symmetrical 1v1 map with plenty of resources and nowhere to hide.

### Research Outpost

> SRI has salvaged many ancient artifacts and brought them to this outpost for further study.

**Research Outpost** is a 1v1 asymmetric map with hyperspace disabled. 

### The Graveyard

> Historians are not quite sure why so many empires met their end in this system. 

**The Graveyard** is a 2v2 symmetric map.

### Assault

> Formerly Hiigaran colonies, these moons now serve as a staging and resupply outpost for the Vaygr.

**Assault** is a 1v2 asymmetric map based on _Thaddis Sabbah_ from the Homeworld 2 campaign. Hyperspace is disabled.

### Standoff

> This system isn't expansive enough for three fleets of warships.

**Standoff** is a 3-player FFA asymmetric map.

### Trig's Bones

> The legendsmiths have long told the tale of Trig Soban, an accomplished Soban mercenary, who in the year 497 traveled to the northern lands to fight for a new employer. Upon arriving at the lord's town Trig found it under siege. Broken and defeated his employer told Trig that he was free to go, the battle obviously lost. But a Soban warrior is bound by honor to fight until the terms of a contract are fulfilled. The legendsmiths say that the lord's dismissal still hung in the air as Trig drew his sword, turned, and marched out of the town, where he proceeded to single-handedly cut a bloody swath to the middle of the enemy encampment. They say he managed to kill their general before he was cut down himself. They say the Soban never recovered the body of their brother. They say that in a rage, the enemy lord had Trig's body scattered across the continent. When we took to the stars the legends traveled with us and to this day, this strange area of space is referred to as Trig's Bones, a memorial to the legendary fighter.

**Trig's Bones** is a 3-player FFA map ported from _Homeworld: Cataclysm_ that features a lot of verticality.

### The Battlefield

> They say it's an honorable place to meet, though don't expect a fair fight.

**The Battlefield** is a 2v2 symmetrical map.

### The Unbound

> Overwhelmed by the Beast, this is the final resting place of the Bentusi.

**The Unbound** is a 4-player CQB FFA map based on Homeworld 2's Mission 11.

### Mining Outpost

> This mining operation is key to Vaygr strategy in the region.

**Mining Outpost** is a 2v3 asymmetrical map with hyperspace disabled.

### The Final Battle

> It is said that Sajuuk blesses those about to enter battle against overwhelming odds.

**The Final Battle** is a 2v3 asymmetrical map, and a remix of Homeworld 2's mission 15.

### The Badlands

> Let us never forget those who journeyed into the howling dark and did not return.

**The Badlands** is a symmetrical 6-player map designed for 3v3 or FFA. It features minimal resources, all of which are located in the center of the map. 

### Garrison

> This heavily defended SRI outpost is the last standing deep within Vaygr territory. 

**Garrison** is a symmetrical 3v3 map with hyperspace disabled. Special ships include the Bentusi-derived Dreadnaught and Drones. 

