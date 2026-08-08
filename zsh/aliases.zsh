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
alias grep="ggrep"
alias lzd="lazydocker"
alias lzg="lazygit"

alias gtoken="gcloud auth print-access-token"
#
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

# Activate .venv: check cwd itself first, else search subdirs (depth 3)
activate() {
  if [[ -f "$PWD/.venv/bin/activate" ]]; then
    source "$PWD/.venv/bin/activate"
    return
  fi

  local matches=("$PWD"/**/.venv/bin/activate(N,om))
  if [[ ${#matches[@]} -eq 0 ]]; then
    echo "no .venv found"
  elif [[ ${#matches[@]} -eq 1 ]]; then
    source "${matches[1]}"
  else
    echo "multiple .venv found, pick one:"
    printf '%s\n' "${matches[@]}"
  fi
}
