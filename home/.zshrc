export ZSH="/usr/share/oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="fishy"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "fishy" "mortalscumbag" "essembeh" "gallifrey" "flazz" "half-life" "wedisagree" "ys" "dieter" )

# Show dots while autocompletion is busy
COMPLETION_WAITING_DOTS="true"

# Use sortable stamps in history
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Dark theme for GTK popups
export GTK_THEME=Adwaita:dark

# GPG password authentication in terminal
export GPG_TTY=$(tty)

# New Google authentication plugin for Kubernetes proxies
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias screen-duplicate="~/.config/polybar/launch.sh"
alias screen-extend="~/.config/polybar/launch.sh"
alias mirrors-rank="sudo reflector --sort=score --country=NL,BE,LU,DE > /etc/pacman.d/mirrorlist"
