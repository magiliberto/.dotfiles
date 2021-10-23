#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH=$PATH:$HOME/scripts
export VISUAL=nvim;
export EDITOR=nvim;

# export TERM=xterm-256color-italic
# export TERM=alacritty

alias ls='ls --color=auto'
alias R='R --silent'
alias tmux='tmux -2'
alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'

# Base-16 color schemes
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
	[ -s "$BASE16_SHELL/profile_helper.sh" ] && \
		eval "$("$BASE16_SHELL/profile_helper.sh")"
base16_solarized-dark

# Color Prompt
cyan=$(tput setaf 6)
magenta=$(tput setaf 5)
yellow=$(tput setaf 3)
reset=$(tput sgr0)
PS1='\[$cyan\]\u\[$reset\]@\[$magenta\]\h\[$reset\]:\[$yellow\]\w\[$reset\]\$ '

# Start Insync
# hash insync-headless 2>/dev/null && insync-headless start

clear
hash neofetch 2>/dev/null && neofetch start
