# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.local/src/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[[ ! -f ~/.aliases ]] || source ~/.aliases


# History
HISTSIZE=1000000000
SAVEHIST=1000000000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS # Ignore consecutive duplicate commands

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)  # Include hidden files.
compdef -d java # Disable java completion, see, https://github.com/ohmyzsh/ohmyzsh/issues/2437


unsetopt nomatch


# vi mode
bindkey -v
export KEYTIMEOUT=1
bindkey -v '^?' backward-delete-char # Fix bug with backspace not working after exiting from normal mode


bindkey "Oc" forward-word
bindkey "Od" backward-word


# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
# precmd() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
# preexec() { echo -ne '\e[2 q' ;} # Use fat shape again before command execution


# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'


# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line


# Autocompetiton
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# Load zsh-syntax-highlighting; should be last.
source /home/kkostin/.local/src/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# To have paths colored instead of underlined
ZSH_HIGHLIGHT_STYLES[path]='none'
# To differentiate aliases from other command types
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
