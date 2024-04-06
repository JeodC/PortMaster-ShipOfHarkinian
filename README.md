## Installation
Follow the guide at the [Ship of Harkinian website](https://www.shipofharkinian.com/setup-guide) for your desired platform to create your oot.otr and/or oot-mq.otr files. Once created put in the `ports/soh` folder. Texture pack files can be added to the `ports/soh/mods` folder. The menu bar cannot be used
for this port, so settings must be manually altered in `shipofharkinian.json` and `imgui.ini`; randomizer seeds must also be generated from a PC.

## Graphics Adjustments
In the `shipofharkinian.json` file there is a setting `"gInternalResolution": 0.5,`. If not using texture packs, change this to `"gInternalResolution": 1.0,` or higher.

## Preset Adjustments
A full list of presets can be viewed at the ShipWright Github repository, inside the [presets.h file](https://github.com/HarbourMasters/Shipwright/blob/fd7dfd8b6f557909c84b88e35df37bc27673fa1e/soh/soh/Enhancements/presets.h). You can create entries in your `shipofharkinian.json` file to adjust these presets. Keep in mind the json is in alphabetical order.

## Default Gameplay Controls
The port uses SDL controller mapping. GPToKeyB is utilized only to allow hotkey exiting.

## Thanks
Nintendo for the game  
HarbourMasters for the native pc port  
fpasteau for the initial build  
Testers and Devs from the PortMaster Discord  




