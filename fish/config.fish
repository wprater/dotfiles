# -*- sh -*-

# tool config

set -x GREP_OPTIONS "--exclude-dir=.svn --exclude-dir=.git --binary-files=without-match"
set -x LESS "-XMcifR"
set -x TZ "America/Los_Angeles"

# personal config

# Prefer US English and use UTF-8.
set -x LANG 'en_US.UTF-8'
set -x LC_ALL 'en_US.UTF-8'

set -x GITROOT "https://github.com/wprater"

# fish config

# set -        CDPATH . ~
# if test -d ~/workspace
#   set -g CDPATH $CDPATH ~/workspace
# end
# if test -d ~/citc
#   set -g CDPATH $CDPATH ~/citc
# end

# Avoid fish_user_path and instead set PATH directly. fish_user_path can be used
# to share a PATH across shells and invocations if set as a universal variable;
# it isn't very useful otherwise. See
# https://github.com/fish-shell/fish-shell/issues/527#issuecomment-253775156
function append_path
  if begin ; count $argv > /dev/null ; and count $argv[1] > /dev/null ; and test -d $argv[1] ; end
    if not contains $argv[1] $PATH
      set PATH $PATH $argv[1]
    end
  end
end

function prepend_path
  if begin ; count $argv > /dev/null ; and count $argv[1] > /dev/null ; and test -d $argv[1] ; end
    if not contains $argv[1] $PATH
      set PATH $argv[1] $PATH
    end
  end
end

function sourceif
  if test -r $argv[1]
    source $argv[1]
  end
end

# Google Cloud SDK
#
# https://cloud.google.com/sdk/

prepend_path "$HOME/local/go_appengine"
prepend_path "$HOME/local/google-cloud-sdk/platform/google_appengine/goroot/bin"
prepend_path "$HOME/local/google-cloud-sdk/platform/google_appengine"
prepend_path "$HOME/local/google-cloud-sdk/bin"

# java
#
# 1. Choose JRE from
#    http://www.oracle.com/technetwork/java/javase/downloads/index.html
# 2. Download the *.tar.gz.
# 3. Extract to ~/local.

set d ~/local/jre*/Contents/Home/bin
prepend_path $d

set -x JAVA_HOME "/Library/Java/JavaVirtualMachines/jdk1.8.0_112.jdk/Contents/Home/"

# ghc
#
# Install via:
#
#   $ brew cask install ghc
#
# Then:
#
#   $ cabal update
#   $ cabal install pandoc
<<<<<<< HEAD

set d /Applications/ghc-*.app/Contents/bin
prepend_path $d
prepend_path ~/.cabal/bin
=======
# set d /Applications/ghc-*.app/Contents/bin
# append_if_exists $d
# append_if_exists ~/.cabal/bin
>>>>>>> general updates. add ssh agent. add 2-line prompt

# Android Tools

test -d ~/Library/Android/sdk ; and set -x ANDROID_HOME ~/Library/Android/sdk
test -d ~/Android/Sdk         ; and set -x ANDROID_HOME ~/Android/Sdk

prepend_path $ANDROID_HOME/platform-tools
prepend_path $ANDROID_HOME/tools
prepend_path $ANDROID_HOME/tools/bin

# Ruby
#
# Install gems via:
#
#   $ gem install $name --user-install

set d ~/.gem/ruby/*/bin
prepend_path $d

# golang
#

# Ubuntu (package is golang-*-go)
set d /usr/lib/go-*/bin
prepend_path $d
# OS X
if type -q go
  set -x GOPATH ~/local/go
  mkdir -p $GOPATH
  prepend_path $GOPATH/bin
end

# Node
#
# NODE_VERSIONS is used by direnv and nodejs-install to make different
# versions of node available; see ~/.direnvrc

set -x NODE_VERSIONS $HOME/.local/share/node/versions
mkdir -p $NODE_VERSIONS

prepend_path $NODE_VERSIONS/(ls $NODE_VERSIONS | sort -n | tail -1)/bin

prepend_path /usr/local/sbin
prepend_path /usr/local/bin

prepend_path "$HOME/local/homebrew/bin"
prepend_path "$HOME/local/homebrew/sbin"
prepend_path (realpath "$HOME/.dotfiles/fish/../bin")
prepend_path "$HOME/local-linux/bin" # $PLATFORM is not readily available, so hardcode
prepend_path "$HOME/local/bin"

# http://fishshell.com/docs/current/faq.html#faq-greeting
set fish_greeting

# https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish
set -g __fish_git_prompt_showupstream "auto"
set -g __fish_git_prompt_showstashstate "1"
set -g __fish_git_prompt_showdirtystate "1"
set -g __fish_git_prompt_show_informative_status

# mkdir -p ~/.rubies
# . $HOME/.config/fish/rubies.fish

# https://github.com/zimbatm/direnv
if type -q direnv
  eval (direnv hook fish)
  # If MANPATH is set, man very helpfully ignores the default search path as defined in
  # /etc/manpath.config (at least on Linux). Therefore, to ensure man searches through
  # the default after direnv fiddles with MANPATH, we explicitly set it to its default value.
  # See http://unix.stackexchange.com/q/344603/49703
  set -x MANPATH (man -w)
end

# if type -q jed
#   set -x EDITOR "jed"
# end

# if type -q atom
#   set -x VISUAL "jed" # or "atom -w"
# end

<<<<<<< HEAD
set -x VISUAL $EDITOR

#if type -q code
#  set -x VISUAL "code -w"
#end

type -q pbcopy  ; or alias pbcopy  "xsel -bi"
type -q pbpaste ; or alias pbpaste "xsel -bo"

. ~/.config/fish/solarized.fish
. ~/.config/fish/ua.fish
=======
if which code-insiders >/dev/null
  set -x EDITOR "code-insiders -n -w"
  set -x VISUAL "code-insiders -n"
end

start-ssh-agent

source ~/.config/fish/aliases.fish
source ~/.config/fish/solarized.fish
>>>>>>> general updates. add ssh agent. add 2-line prompt

sourceif ~/.ssh/etc/fish/envrc

status --is-interactive; and source (rbenv init -|psub)
