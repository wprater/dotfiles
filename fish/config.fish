# -*- sh -*-

# tool config

# set -x GREP_OPTIONS "--exclude-dir=.svn --exclude-dir=.git --binary-files=without-match"
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

set -x JAVA_HOME "/Library/Java/JavaVirtualMachines/jdk1.8.0_161.jdk/Contents/Home/"

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

set d /Applications/ghc-*.app/Contents/bin
prepend_path $d
prepend_path ~/.cabal/bin

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

# test -d ~/bin/apache-maven-3.0.3 ; and set -x M2_HOME ~/bin/apache-maven-3.0.3
# append_path $M2_HOME/bin

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

set -x N_PREFIX "$HOME/n";

prepend_path "$N_PREFIX/bin"

prepend_path /usr/local/sbin
prepend_path /usr/local/bin

prepend_path "$HOME/local/homebrew/bin"
prepend_path "$HOME/local/homebrew/sbin"
prepend_path (realpath "$HOME/.dotfiles/fish/../bin")
prepend_path "$HOME/local-linux/bin" # $PLATFORM is not readily available, so hardcode
prepend_path "$HOME/local/bin"

prepend_path "$HOME/.yarn-cache/.global/node_modules/.bin"
prepend_path "$HOME/.yarn/bin"
prepend_path "$HOME/usr/local/opt/go/libexec/bin"

test -d ~Library/Python/3.7/bin ; and prepend_path "$HOME/Library/Python/3.7/bin"

test -d ~/bin/flutter/bin ; and prepend_path "$HOME/bin/flutter/bin"

# http://fishshell.com/docs/current/faq.html#faq-greeting
set fish_greeting

# https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish
set -g __fish_git_prompt_showupstream "auto"
set -g __fish_git_prompt_showstashstate "1"
set -g __fish_git_prompt_showdirtystate "1"
set -g __fish_git_prompt_show_informative_status

# https://github.com/zimbatm/direnv
if type -q direnv
  eval (direnv hook fish)
  # If MANPATH is set, man very helpfully ignores the default search path as defined in
  # /etc/manpath.config (at least on Linux). Therefore, to ensure man searches through
  # the default after direnv fiddles with MANPATH, we explicitly set it to its default value.
  # See http://unix.stackexchange.com/q/344603/49703
  set -x MANPATH (man -w)
end

if which code-insiders >/dev/null
  set -x EDITOR "code-insiders -n -w"
  set -x REACT_EDITOR "code-insiders -n -w"
end

set -x VISUAL $EDITOR

type -q pbcopy  ; or alias pbcopy  "xsel -bi"
type -q pbpaste ; or alias pbpaste "xsel -bo"

start-ssh-agent

. ~/.config/fish/ua.fish

sourceif ~/.config/fish/aliases.fish
sourceif ~/.config/fish/solarized.fish

sourceif ~/.ssh/etc/fish/envrc

status --is-interactive; and source (rbenv init -|psub)
# status --is-interactive; and source (swiftenv init -|psub)

# begin appcenter completion
# appcenter --completion-fish | source
# end appcenter completion
