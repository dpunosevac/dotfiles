#!/bin/sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

source "$CONFIG_DIR/icons.sh"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME=$INFO

  case $VOLUME in
    7[5-9]|[8-9][0-9]|100) ICON=${ICONS_VOLUME[4]} ;;
    [5-6][0-9]|7[0-4]) ICON=${ICONS_VOLUME[3]};;
    2[5-9]|[3-4][0-9]) ICON=${ICONS_VOLUME[2]} ;;
    [1-9]|1[0-9]|2[0-4]) ICON=${ICONS_VOLUME[1]} ;;
    0) ICON=${ICONS_VOLUME[0]}
  esac

  sketchybar --set $NAME icon="$ICON" label="$VOLUME%"
fi
