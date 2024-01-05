#!/bin/sh

# The wifi_change event supplies a $INFO variable in which the current SSID
# is passed to the script.

source "$CONFIG_DIR/icons.sh"

if [ "$SENDER" = "wifi_change" ]; then
  NETWORK_NAME=$(/Sy*/L*/Priv*/Apple8*/V*/C*/R*/airport -I | awk '/ SSID:/ {print $2}')
  IS_VPN=$(scutil --nwi | grep -m1 'utun' | awk '{ print $1 }')

  if [[ $IS_VPN != "" ]]; then
	  ICON=$ICON_VPN
	  LABEL="VPN"
  elif [[ $NETWORK_NAME != "" ]]; then
	  ICON=$ICON_WIFI
	  LABEL=$NETWORK_NAME
  else
	  ICON=$ICON_WIFI_OFF
	  LABEL="Not Connected"
  fi

  sketchybar --set $NAME icon="${ICON}" label="${LABEL}"
fi
