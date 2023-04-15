function __cd_explicit_path --description "Find explicit path"
  string length -q "$argv"; or set argv "$HOME"
  set argv (realpath $argv)
  echo $argv
end

function __cd_remove_existed --description "Remove an existed item from a list"
  set -l remove_item  "$argv[1]"
  set -l from_list    "$argv[2]"
  set -l tmp_list

  set from_list (echo $from_list | sed "s`[[:space:]]\+` `g")
  for item in (string split ' ' $from_list)
    if not test $item = $remove_item
      set -a tmp_list $item
    end
  end
  echo "$tmp_list"
end

function __cd_int_check --description "Check a variable is an integer or not"
  if test (count $argv) -gt 1
    echo "__cd_int_check: Superfluous argument"
    return 1
  end
  string match -qr '^[0-9]+' "$argv"; and return 0; or return 1
end

function cd --description "Wrapper function for change directory"
  set -l cd_status 0

  # Init cd_history in new shell
  set -q cd_history; or set -g cd_history
  # Parse arguments
  set -l options (fish_opt -s l -l list)
  set -a options (fish_opt -s i -l index --required-val)
  argparse $options -- $argv; or return 1

  # Check if using 2 options
  if set -q _flag_index; and set -q _flag_list
    echo "cd: Only use one option at a time"
    return 1
  end

  if set -q _flag_list        # Using list option
    test (count $argv) -gt 0; and echo "cd: Print dir history only, ignore other arguments"
    set -l index 1
    for dir in (string split ' ' $cd_history)
      echo "$index - $dir"
      set index (math $index + 1)
    end
    return 0
  else if set -q _flag_index  # If using index option
    set _flag_index (string trim -c ' ' $_flag_index)
    if not __cd_int_check $_flag_index
      echo "cd: $_flag_index is not an integer"
      return 1
    end
    if test $_flag_index -lt 1; or test $_flag_index -gt (count (string split ' ' $cd_history))
      echo "cd: Invalid history index"
      return 1
    end
    test (count $argv) -gt 0; and echo "cd: Change directory to index $_flag_index, ignore other arguments"
    set -l list_dir (string split ' ' $cd_history)
    set argv $list_dir[$_flag_index]
  else # default case
    if not test "$argv" = '-'
      set argv (__cd_explicit_path "$argv")
    else
      builtin cd -
      set cd_status $status
      if test $cd_status -eq 0
        set -l dir (pwd)
        set cd_history (__cd_remove_existed "$dir" "$cd_history")
        set cd_history "$dir $cd_history"
        set cd_history (string trim -c ' ' $cd_history)
      end
      return $cd_status
    end
  end

  builtin cd $argv
  set cd_status $status
  if test $cd_status -eq 0
    set cd_history (__cd_remove_existed "$argv" "$cd_history")
    set cd_history "$argv $cd_history"
    set cd_history (string trim -c ' ' $cd_history)
  end
  return $cd_status
end
