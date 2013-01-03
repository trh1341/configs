# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="terminalparty"
#ZSH_THEME="kphoen"
#ZSH_THEME="blinks"
ZSH_THEME="dallas"
#ZSH_THEME="gurgeh"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(osx brew git ruby)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/opt/local/bin:/bin:/usr/bin:/usr/local/bin:/Users/dpayne2/bin:/usr/X11/bin:/usr/local/git/bin:$PATH

#postgreSQL
export PATH=/Library/PostgreSQL/bin:$PATH

alias untar='tar -xvf'
alias dvl='ssh -X lxdm603m7'
alias ftp_dvl='sftp lxdm603m7'
alias startjdev="/users/dpayne2/oracle/middleware/jdeveloper/jdev/bin/jdev"
alias grey="ssh -X -p 2222 dpayne@grey.dyndns.tv"

export MPD_HOST="http://www.mympd.in"
export MPD_PORT="6600"
export SVN_EDITOR="vim"

#Java setup
export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home
export PATH=$JAVA_HOME/bin:$PATH
export MEM_MAX_PERM_SIZE="-XX:MaxPermSize=2048m"
export USER_MEM_ARGS="${MEM_ARGS} ${MEM_MAX_PERM_SIZE} -verbose:gc -XX:+PrintGCTimeStamps -XX:+PrintGCDetails -Xloggc"

#maven
export M2_HOME=/maven3
#export M2_HOME=/Users/dpayne2/Workspace/neo/maven/3.0.3
export MAVEN_OPTS="-Xmx512m -XX:PermSize=2048m -XX:MaxPermSize=2048m"
#export MAVEN_OPTS="-Xmx512m -XX:PermSize=64m -XX:MaxPermSize=64m"
export PATH=$M2_HOME/bin:$PATH

#ruby on rails setup
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

export SDK_ROOT="/Users/dpayne2/Library/android/tools/"

export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export MANPATH=/opt/local/share/man:$MANPATH
export DISPLAY=:0.0
alias c="cd"
alias c.="cd .."
alias v="vim"
alias sv="sudo vim"
alias m="mvn"
alias mc="mvn clean"
alias mci="mvn clean install"
alias mcid="mvn clean install -DskipTests"
alias mcidd="mvn clean install -DskipTests -Dskip.integration.test=true"
alias mcij="mvn clean install jetty:run"
alias mcijd="mvn clean install -DskipTests jetty:run"
alias mcijdd="mvn clean install -DskipTests -Dskip.integration.test=true jetty:run"
alias c="clear"
alias g="grep"
alias k="kill"
alias k9="kill -9"
alias tf="tail -f"
alias ps="ps -ax"
alias top="htop"
alias work="cd ~/Workspace"

echo "\n"
fortune
