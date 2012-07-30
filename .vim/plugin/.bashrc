if [ "$TERM" != 'dumb' ] && [ -n "$BASH" ] && [ -n "$PS1" ]
then
    if [ `/usr/bin/whoami` = 'root' ]
        then
          #export PS1='[\u@\h \W]\$ '
          export PS1='\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\]\[\e[0;31m\]\$\[\e[m\]\[\e[0;32m\] '
        else
          #export PS1='[\u@\h \W \$ ' 
          export PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\W\[\e[m\]\[\e[m\] \[\e[1;32m\]\$\[\e[m\]\[\e[1;37m\] ' 
        #then
        #    export PS1='\[\033[01;31m\]\h \[\033[01;34m\]\W \$ \[\033[00m\]'
        #else
        #    export PS1='\[\033[01;32m\]\u@\h \[\033[01;34m\]\W \$ \[\033[00m\]'
    fi
fi

# Console Colors
if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0222222" #black
    echo -en "\e]P8222222" #darkgrey
    echo -en "\e]P1803232" #darkred
    echo -en "\e]P9982b2b" #red
    echo -en "\e]P25b762f" #darkgreen
    echo -en "\e]PA89b83f" #green
    echo -en "\e]P3aa9943" #brown
    echo -en "\e]PBefef60" #yellow
    echo -en "\e]P4324c80" #darkblue
    echo -en "\e]PC2b4f98" #blue
    echo -en "\e]P5706c9a" #darkmagenta
    echo -en "\e]PD826ab1" #magenta
    echo -en "\e]P692b19e" #darkcyan
    echo -en "\e]PEa1cdcd" #cyan
    echo -en "\e]P7ffffff" #lightgrey
    echo -en "\e]PFdedede" #white
    clear #for background artifacting
fi

# Extract Stuff
extract () {
if [ -f $1 ]; then
	case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       unrar e $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
else
         echo "'$1' is not a valid file"
fi
}

# Define Stuff
define () {
lynx -dump "http://www.google.com/search?hl=en&q=define%3A+${1}&btnG=Google+Search" | grep -m 3 -w "*"  | sed 's/;/ -/g' | cut -d- -f1 > /tmp/templookup.txt
            if [[ -s  /tmp/templookup.txt ]] ;then    
                until ! read response
                    do
                    echo "${response}"
                    done < /tmp/templookup.txt
                else
                    echo "Sorry $USER, I can't find the term \"${1} \""                
            fi    
rm -f /tmp/templookup.txt
}

# Calculate Stuff
calc(){ 
	echo "$*" | bc;
}

# Bash Completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Aliases
if [ -f .alias ]; then
    . .alias
fi

# Other
export OOO_FORCE_DESKTOP=gnome
export MOZ_DISABLE_PANGO=1
export GREP_COLOR="1;33"
alias grep='grep --color=auto'
eval `dircolors -b`

# set colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'                           
export LESS_TERMCAP_so=$'\E[01;44;33m'                                 
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
