# Show loadavg when too high
set -l load1m $cyan 'load: ' (uptime | grep -o '[0-9]\+\.[0-9]\+' | head -n1)
# set -l load1m_test (math $load1m \* 100 / 1)
# if test $load1m_test -gt 100
#     # set -l load1m $red $load1m
# end

function fish_right_prompt
  set_color $fish_color_autosuggestion ^/dev/null; or set_color 555
  date "+%H:%M:%S"
  set_color normal
end
