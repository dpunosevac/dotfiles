#!/bin/zsh

######### Alias ##########
alias cl='clear'
alias histgrep='echo "[Tip] Use !number to execute the command" && history -i | grep' # -i for the timestamp
alias l='ls -A -l -h --color=auto' # All file except . and .., list view, display unit suffix for the size
alias ..='cd ..'
alias gs='git status'
alias gpl='git pull'
alias gp='git push'
alias gc='git commit -m'
alias vim='nvim'

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

uuid() {
	if [ -z "$1" ]
	then
		echo "No argument supplied"
	fi
	
	uuids=""
	for i in `seq 1 $1`
	do
		uuids="$uuids $(uuidgen | tr '[:upper:]' '[:lower:]')\n"
	done
	
	echo $uuids | pbcopy
}

