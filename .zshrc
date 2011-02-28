# Colors are nice.
autoload -U colors && colors

# Set specific histories, etc., for the different hosts.
autoload -U compinit
compinit -d ~/.zcompdumps/`hostname -s`
setopt autocd
export HISTFILE=~/.histfile-`hostname -s`
export HISTSIZE=1000
export SAVEHIST=5000
export EDITOR="vim"
export SVN_EDITOR=$EDITOR
export VISUAL=$EDITOR
export PATH="$PATH:$HOME/bin/:/usr/texbin/"

bindkey -v

# 'Home' key
bindkey -M viins "\e[H" beginning-of-line
bindkey -M vicmd "\e[H" beginning-of-line
# 'End' key
bindkey -M viins "\e[F" end-of-line
bindkey -M vicmd "\e[F" end-of-line
bindkey -M viins OF end-of-line

# {jj,JJ} => <ESC>
bindkey -M viins "jj" vi-cmd-mode
bindkey -M viins "JJ" vi-cmd-mode

# Annoying not to have
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

# End of lines added by compinstall

# We want our completions to be colorful
zmodload -a zcomplist

# Aliases and functions
if [ -d ~/.zfunctions ] ;then
	fpath=(~/.zfunctions $fpath)
	autoload -U ${fpath[1]}/* 2>/dev/null >&2
    autoload -U ${fpath[1]}/*.zwc(:t) 2>/dev/null >&2
fi
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions

autoload title
# precmd is called just before the prompt is printed
function precmd() {
  title "zsh" "%m(%55<...<%~)"
}

# preexec is called just before any command line is executed
function preexec() {
  title "$1" "%m(%35<...<%~)"
}

# system-wide aliases
# We like ls with colors, but it's different on FreeBSD vs Linux
if [[ $OSTYPE = freebsd* || $OSTYPE = darwin* ]] ; then
	# see if we have gls
	if whence gls 2>/dev/null >&2 ; then
		eval `gdircolors -b`
		alias ls='gls --color=auto'
		zstyle ':completion:*' list-colors '' # use gdircolors
	else # we have to use BSD color syntax
		DIR=Gx
		SYM_LINK=Fx
		SOCKET=Fx
		PIPE=dx
		EXE=Cx
		BLOCK_SP=Dx
		CHAR_SP=Dx
		EXE_SUID=hb
		EXE_GUID=ad
		DIR_STICKY=Ex
		DIR_WO_STICKY=Ex
		export LSCOLORS="$DIR$SYM_LINK$SOCKET$PIPE$EXE$BLOCK_SP$CHAR_SP$EXE_SUID$EXE_GUID$DIR_STICKY$DIR_WO_STICKY"
		alias ls='ls -G'
		zstyle ':completion:*' list-colors '' # use something else
	fi
elif [[ $OSTYPE = cygwin*  ||  $OSTYPE == linux* ]]; then
		eval `dircolors -b`
        alias ls='ls --color'
		zstyle ':completion:*' list-colors '' # use gdircolors
# no colors, we'll have to use flags
else
	alias ls='ls -F'
fi
alias vgrep='grep -v'
alias grep='grep --color'
alias tea='tee -a'
alias mkpass1='openssl rand -base64 12'
alias mkpass='openssl rand -base64'
alias ll='ls -l'

if [[ $OSTYPE = darwin* ]] ; then # Mac OS X is generally case-insensitive
	unsetopt caseglob
fi

# Last but not least, the prompt
prompt_time="%{$fg[blue]%}%D{%H:%M:%S}%{$reset_color%}"
unames="%{$fg[cyan]%}`uname -s`%{$reset_color%}"
working_dir="%{$fg[green]%}%~%{$reset_color%}"
PROMPT="$prompt_time $unames $working_dir
%{$fg[$(hostnamecolor)]%}%m%{$reset_color%} %{$fg[yellow]%}%#%{$reset_color%} "

# vim :ts=4:ft=zsh
export VERSIONER_PYTHON_PREFER_32_BIT=yes
