function xx_fish_prompt --description 'Write out the prompt'

  # Use after set_color to reset bold
  if not set -q __fish_prompt_color_normal
    set -g __fish_prompt_color_normal (set_color normal)
  end

  if not set -q __fish_prompt_color_hostname
    set -g __fish_prompt_color_hostname (set_color -o $fish_color_hostname)
  end

  if not set -q __fish_prompt_color_cwd
    set -g __fish_prompt_color_cwd (set_color $fish_color_cwd)
  end

  if not set -q __fish_prompt_color_git
    set -g __fish_prompt_color_git (set_color $fish_color_git)
  end

  if not set -q __fish_prompt_hostname
    # once fish 2.5 is everywhere, use prompt_hostname here
    if test -d /etc/goobuntu
      set -g __fish_prompt_hostname goobuntu
    else if begin ; hostname | grep -q syd ; end
      set -g __fish_prompt_hostname syd@gandi
    else
      set -g __fish_prompt_hostname (hostname -s|cut -d \- -f 1|tr A-Z a-z)
    end
  end

  # If commands takes longer than 10 seconds, notify user on completion if Terminal
  # in background. (Otherwise e.g. reading man pages for longer than 10 seconds will
  # trigger the notification.) Inspired by https://github.com/jml/undistract-me/issues/32.
  if test $CMD_DURATION
    if test $CMD_DURATION -gt (math "1000 * 10")
      if not terminal-frontmost
        set secs (math "$CMD_DURATION / 1000")
        # It's not possible to raise the window via the notification; see
        # https://stackoverflow.com/a/33808356
        notify "$history[1]" "(status $status; $secs secs)"
      end
    end
  end

  echo -n -s "$__fish_prompt_color_hostname" "$__fish_prompt_hostname" "$__fish_prompt_color_normal" ':' "$__fish_prompt_color_cwd" (prompt_pwd) "$__fish_prompt_color_git" (__fish_git_prompt "#%s") "$__fish_prompt_color_normal" '$ '

end

# name: clearance
# ---------------
# Based on idan. Display the following bits on the left:
# - Virtualenv name (if applicable, see https://github.com/adambrenecki/virtualfish)
# - Current directory name
# - Git branch and dirty state (if inside a git repo)

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty --untracked-files=no ^/dev/null)
end

function fish_prompt
  set -l last_status $status

  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l normal (set_color normal)

  set -l cwd $blue(pwd | sed "s:^$HOME:~:")

  # If commands takes longer than 10 seconds, notify user on completion if Terminal
  # in background. (Otherwise e.g. reading man pages for longer than 10 seconds will
  # trigger the notification.) Inspired by https://github.com/jml/undistract-me/issues/32.
  if test $CMD_DURATION
    if test $CMD_DURATION -gt (math "1000 * 10")
      if not terminal-frontmost
        set secs (math "$CMD_DURATION / 1000")
        # It's not possible to raise the window via the notification; see
        # https://stackoverflow.com/a/33808356
        notify "$history[1]" "(status $status; $secs secs)"
      end
    end
  end

  # Output the prompt, left to right

  # Add a newline before new prompts
  echo -e ''

  # Display [venvname] if in a virtualenv
  if set -q VIRTUAL_ENV
      echo -n -s (set_color -b cyan black) '[' (basename "$VIRTUAL_ENV") ']' $normal ' '
  end

  # Print pwd or full path
  echo -n -s $cwd $normal

  # Show git branch and status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info '(' $yellow $git_branch "±" $normal ')'
    else
      set git_info '(' $green $git_branch $normal ')'
    end
    echo -n -s ' · ' $git_info $normal
  end

  set -l prompt_color $red
  if test $last_status = 0
    set prompt_color $normal
  end

  # Terminate with a nice prompt char
  echo -e ''
  echo -e -n -s $prompt_color '⟩ ' $normal
end
