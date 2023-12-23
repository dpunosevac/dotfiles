#!/bin/zsh

######### Alias ##########
alias cl='clear'
alias histgrep='echo "[Tip] Use !number to execute the command" && history -i | grep' # -i for the timestamp
alias l='ls -A -l -h --color=auto' # All file except . and .., list view, display unit suffix for the size
alias weather="curl 'https://wttr.in'"

# These personal aliases require various other env var from .zshrc
alias dot="cd \"$DOT_DIR\""

########## Small Functions ##########

mkcd() { mkdir -p $1; cd $1 }

cpwd() { 
	if [[ $1 ]]
	then
		echo $(pwd)/$1 | pbcopy 
	else
		pwd | pbcopy
	fi
}

#uuid() {
#	if [[ $1 ]]
#	then
#		uuids = uuidgen | tr '[:upper:]' '[:lower:]'
#		for i in {1..$1 - 1}
#		do
#			uuids = ${uuids} uuidgen | tr '[:upper:]' '[:lower:]'
#		done
#	else
#		uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '\n' | pbcopy
#	fi
#}
