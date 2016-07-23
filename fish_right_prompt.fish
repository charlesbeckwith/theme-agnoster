# right prompt for agnoster theme
# shows vim mode status

set right_segment_separator \uE0B2
set segment_separator \uE0B0
set -g agnoster_right_current_bg 

function right_prompt_segment -d "Function to draw a right segment"
  set -l bg
  set -l fg
  if [ -n "$argv[1]" ]
    set bg $argv[1]
  else
    set bg normal
  end
  if [ -n "$argv[2]" ]
    set fg $argv[2]
  else
    set fg normal
  end
  if [ "$agnoster_right_current_bg" != 'NONE' -a "$argv[1]" != "$agnoster_right_current_bg" ]
    set_color -b normal 
    set_color $bg
    echo -n "$right_segment_separator"

    set_color -b $bg
    set_color $fg
  else
    set_color -b $bg
    set_color $fg
  end
  set agnoster_right_current_bg $argv[1]
  if [ -n "$argv[3]" ]
    echo -n -s " " $argv[3]
  end
end

function prompt_start_right -d "Close open segments"
  set -l bg
  if [ -n "$argv[1]" ]
    set bg $argv[1]
  else
    set bg white
  end
  if [ -n $current_bg ]
    set_color -b $bg
  end
end

function prompt_git -d "Display the current git state"
  set -l ref
  set -l dirty
  if command git rev-parse --is-inside-work-tree >/dev/null 2>&1
    set dirty (parse_git_dirty)
    set ref (command git symbolic-ref HEAD 2> /dev/null)
    set branch_symbol \uE0A0
    set -l branch (echo $ref | sed  "s-refs/heads/-$branch_symbol -")
    if [ $status -gt 0 ]
      set -l branch (command git show-ref --head -s --abbrev |head -n1 2> /dev/null)
      set ref "➦ $branch "
    end
        if [ "$dirty" != "" ]

      prompt_start_right yellow
      right_prompt_segment yellow black "$dirty $branch"
    else
 
      prompt_start_right green
      right_prompt_segment green black "$dirty $branch $segment_seperator"
    end
  end
end



function end_right_prompt
  if [ -n $agnoster_right_current_bg ]
        set_color -b normal
        set_color $agnoster_right_current_bg
  end
  set -g agnoster_right_current_bg 
end

function prompt_vi_mode -d 'vi mode status indicator'
  switch $fish_bind_mode
      case default
        right_prompt_segment green black "N"
      case insert
        right_prompt_segment blue black "I"
      case visual
        right_prompt_segment red black "V"
    end
end

function fish_right_prompt -d 'Prints right prompt'

  type -q git; and prompt_git
  if set -q __fish_vi_mode
    set -l first_color black
    set_color $first_color
    echo "$right_segment_separator"
    prompt_vi_mode
  end
  end_right_prompt
end
