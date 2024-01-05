#!/bin/sh

source "$CONFIG_DIR/icons.sh"

STATE="$(echo "$INFO" | jq -r '.state')"

if [ "$STATE" = "playing" ]; then
  APP="$(echo "$INFO" | jq -r '.app')"
  ARTIST="$(echo "$INFO" | jq -r '.artist')"
  TRACK="$(echo "$INFO" | jq -r '.title')"
  MEDIA="${ARTIST} - ${TRACK}"

  if [ "$APP" = "Deezer" ]; then
    ICON=${ICON_DEEZER}
  elif [ "$APP" = "Spotify" ]; then
    ICON=${ICON_SPOTIFY}
  elif [ "$APP" = "Google Chrome" ]; then
    ICON=${ICON_WEB}
  else
    ICON=${ICON_MUSIC}
  fi

  sketchybar --set media label="$MEDIA" icon="$ICON" drawing=on
else
  sketchybar --set media drawing=off
fi
