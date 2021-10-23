#
# ~/.bash_profile
#

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

[[ $(fgconsole 2> /dev/null) == 1 ]] && exec startx --vt1
[[ -f ~/.bashrc ]] && . ~/.bashrc
