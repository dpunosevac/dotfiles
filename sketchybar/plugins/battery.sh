#!/bin/sh

source "$CONFIG_DIR/icons.sh"

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
  exit 0
fi

case ${PERCENTAGE} in
  100) ICON=${ICONS_BATTERY[10]} ;;
  9[0-9]) ICON=${ICONS_BATTERY[9]} ;;
  8[0-9]) ICON=${ICONS_BATTERY[8]} ;;
  7[0-9]) ICON=${ICONS_BATTERY[7]} ;;
  6[0-9]) ICON=${ICONS_BATTERY[6]} ;;
  5[0-9]) ICON=${ICONS_BATTERY[5]} ;;
  4[0-9]) ICON=${ICONS_BATTERY[4]} ;;
  3[0-9]) ICON=${ICONS_BATTERY[3]} ;;
  2[0-9]) ICON=${ICONS_BATTERY[2]} ;;
  1[0-9]) ICON=${ICONS_BATTERY[1]} ;;
  *) ICON=${ICONS_BATTERY[0]}
esac

if [[ $CHARGING != "" ]]; then
  ICON="${ICON}${ICON_CHARGING}"
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set $NAME icon="$ICON" label="${PERCENTAGE}%"
