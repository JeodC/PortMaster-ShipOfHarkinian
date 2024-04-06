#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
source $controlfolder/device_info.txt
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

# Set variables
GAMEDIR="/$directory/ports/soh"

# Exports
export LD_LIBRARY_PATH="$GAMEDIR/libs:/usr/lib"

cd $GAMEDIR

# Setup controls
$ESUDO chmod 666 /dev/tty1
$ESUDO chmod 666 /dev/uinput

# Function to apply settings from preset.ini to shipofharkinian.json
apply_settings() {
    set -x  # Enable debugging output
    # Check preset value and copy preset.json accordingly
    preset_value=$(grep -Po 'preset=\K\w+' config.ini)
    case $preset_value in
        default)
            cp "presets/default.json" "shipofharkinian.json"
            ;;
        vanillaplus)
            cp "presets/vanillaplus.json" "shipofharkinian.json"
            ;;
        enhanced)
            cp "presets/enhanced.json" "shipofharkinian.json"
            ;;
        *)
            cp "presets/default.json" "shipofharkinian.json"
            ;;
    esac

	# Define array of keys to extract
	keys=("internalresolution" "interpolationfps" "authenticlogo" "disablelod" "disabledrawdistance" "disablekokiridrawdistance" "usecustomtextures")

	# Iterate over keys and extract corresponding values from preset.ini
	for key in "${keys[@]}"; do
		value=$(grep -Po "${key}=\K[^;]+" config.ini)
		declare "$key=$value"
	done

    # Modify shipofharkinian.json according to additional options
    sed -i -E \
        -e "s/gAltAssets\": [01]+,/gAltAssets\": $usecustomtextures,/" \
        -e "s/gAuthenticLogo\": [01],/gAuthenticLogo\": $authenticlogo,/" \
        -e "s/gDisableLOD\": [01]+,/gDisableLOD\": $disablelod,/" \
        -e "s/gDisableDrawDistance\": [01]+,/gDisableDrawDistance\": $disabledrawdistance,/" \
        -e "s/gDisableKokiriDrawDistance\": [01]+,/gDisableKokiriDrawDistance\": $disablekokiridrawdistance,/" \
        -e "s/gInternalResolution\": [0-9]+(\.[0-9]+)?,/gInternalResolution\": $internalresolution,/" \
        -e "s/gInterpolationFPS\": [0-9]+,/gInterpolationFPS\": $interpolationfps,/" \
        shipofharkinian.json
    set +x  # Disable debugging output
}

# Call the function
apply_settings > settings.log 2>&1  # Redirect output to settings.log

# Run the game
echo "Loading, please wait... (might take a while!)" > /dev/tty0
$GPTOKEYB "soh.elf" -c "opt.gptk" & 
SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
./soh.elf
$ESUDO systemctl restart oga_events & 
printf "\033c" >> /dev/tty1
printf "\033c" > /dev/tty0