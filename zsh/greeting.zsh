#!/bin/zsh

# Dusan's Custom Greeting Msg
function zsh_greeting() {
  # Getting the battery info
  batlv=-1
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [[ -a /sys/class/power_supply/BAT0/capacity ]]; then
      batlv=$(cat /sys/class/power_supply/BAT0/capacity)
    elif [[ -a /sys/class/power_supply/BAT1/capacity ]]; then
      batlv=$(cat /sys/class/power_supply/BAT1/capacity)
    fi
  elif command -v pmset &> /dev/null; then
    batlv=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
  fi

  # Colors
  normal='\033[0m'

  red='\033[0;31m'
  brred='\033[1;31m'
  green='\033[0;32m'
  brgreen='\033[1;32m'
  yellow='\033[0;33m'
  bryellow='\033[1;33m'
  blue='\033[0;34m'
  brblue='\033[1;34m'
  magenta='\033[0;35m'
  brmagenta='\033[1;35m'
  cyan='\033[0;36m'
  brcyan='\033[1;36m'

  # Setting battery colors
  if [[ $batlv == 1 ]]; then
    batcolo="$red"
    batlv="Error in the battery "
  elif [[ $batlv -ge 80 ]]; then
    batcolo="$brcyan"
  elif [[ $batlv -gt 40 ]]; then
    batcolo="$green"
  else
    batcolo="$red"
  fi

  # Collection of Eni ASCII arts
  eni=(
    '
       |\__/,|     _
     _.|o o  |_   ) )
    -(((---(((--------
    ' \
    '
       /\_______/\
      /   o   o   \
     (  ==  ^  ==  )
      )           (
     (             )
     ( (  )   (  ) )
    (__(__)___(__)__)
    ' \
    '
                           _
          |\      _-``---,) )
    ZZZzz /,`.-```    -.   /
         |,4-  ) )-,_. ,\ (
        `---``(_/--`  `-`\_)
    ' \
    '
          /\_/\ _______
         = o_o =  _ _  \     _
         (__^__)   __(  \.__) )
      (@)<_____>__(_____)____/
        ♡ ~~ ♡ Eni ♡ ~~ ♡
    ' \
    '
       |\__/,|        _
       |_ _  |.-----.) )
       ( T   ))        )
      (((^_(((/___(((_/
    ' \
  )
  # 1. RANDOM is biased toward the lower index
  # 2. Array index in ZSH starts at 1
  eni=${eni[ $(( RANDOM % ${#eni[@]} + 1 )) ]}

  # Other information
  my_hostname=$(hostname -s)
  timestamp="$(date -I) $(date +"%T")"
  uptime=$(uptime | grep -ohe 'up .*' | sed 's/,//g' | awk '{ print $2" "$3 " " }')

  # Greeting msg
  echo
  echo -e "  " "$brgreen" "Welcome back $USER!"                       "$normal"
  echo -e "  " "$brred"   "$eni"                                      "$normal"
  echo -e "  " "$yellow"  " Zsh Open:\t"   "$bryellow$timestamp"     "$normal"
  echo -e "  " "$blue"    " Hostname:\t"   "$brmagenta$my_hostname"  "$normal"
  echo -e "  " "$magenta" " Uptime  :\t"   "$brblue$uptime"          "$normal"
  echo -e "  " "$cyan"    "󱈏 Battery :\t"   "$batcolo$batlv%"         "$normal"
  echo
}

