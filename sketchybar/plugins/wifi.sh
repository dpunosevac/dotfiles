#!/bin/sh

# The wifi_change event supplies a $INFO variable in which the current SSID
# is passed to the script.

source "$CONFIG_DIR/icons.sh"

if [ "$SENDER" = "wifi_change" ]; then
    # Detect Wi-Fi device (usually en0 or en1)
    WIFI_DEVICE=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $NF}')

    # Get SSID using ipconfig
    SSID=$(ipconfig getsummary "$WIFI_DEVICE" | grep ' SSID : ' | awk -F ': ' '{print $2}')
    IS_VPN=$(scutil --nwi | grep -m1 'utun' | awk '{ print $1 }')

  if [[ $IS_VPN != "" ]]; then
	  ICON=$ICON_VPN
	  LABEL="VPN"
  elif [[ $SSID != "" ]]; then
	  ICON=$ICON_WIFI
  else
	  ICON=$ICON_WIFI_OFF
	  LABEL="Not Connected"
  fi

  sketchybar --set $NAME icon="${ICON}" label="${LABEL}"
fi
