function __qGitInfo --description "Get git information"
  # import color
  # eval (cat ~/.config/fish/functions/__qEnv/colors)
  source ~/.config/fish/themes/mocha.fish

  # Check git installed
  if not command -sq git
    return 1
  end

  # get current branch name
  set -l git_branch_name  (git branch --show-current 2>/dev/null)
  set -l git_rev_head     (git rev-parse --short HEAD 2>/dev/null)
  if test -z "$git_branch_name"
    if test -z "$git_rev_head"
      # not a git directory
      printf '\n'
      return 1
    end
    # abnormal case, can't get branch name but get a HEAD rev id
    set_color -o
    set_color $yellow;  printf '('
    set_color $red;     printf 'HEAD'
    set_color normal
    set_color $white;    printf '::'
    set_color -o
    set_color $green;   printf '%s' (_ "$git_rev_head")
    set_color $yellow;  printf ')\n'
    return 0
  end

  # normal case, get correct branch name
  set_color -o
  set_color $yellow;  printf '('
  set_color $red;     printf 'git'
  set_color normal
  set_color $white;    printf '::'
  set_color -o
  set_color $blue;   printf '%s' (_ "$git_branch_name")
  set_color $yellow;  printf ')\n'
  return 0
end
